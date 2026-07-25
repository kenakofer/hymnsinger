#!/usr/bin/env python3
import xml.etree.ElementTree as ET
import csv

'''
TODO
- Accidentals
- Output to syntactically correct lilypond notes
'''
FORCE_FLAT = ['dff', 'df', 'eff', 'ef', 'fb', 'gff', 'gb', 'aff', 'ab', 'bff', 'bf', 'cb']
PREFER_FLAT = ['c', 'df', 'd', 'ef', 'e', 'f', 'gb', 'g', 'af', 'a', 'bf', 'b']
PREFER_BAL = ['c', 'cs', 'd', 'ef', 'e', 'f', 'fs', 'g', 'gs', 'a', 'bf', 'b']
PREFER_SHARP = ['c', 'cs', 'd', 'ds', 'e', 'f', 'fs', 'g', 'gs', 'a', 'as', 'b']
FORCE_SHARP = ['bs', 'cs', 'css', 'ds', 'dss', 'es', 'fs', 'fss', 'gs', 'gss', 'as', 'ass']

def get_pitch_from_note(note):
    pitch_elem = note.find('pitch')
    return int(pitch_elem.text) if pitch_elem is not None else None

def get_duration_in_beats(duration_type):
    duration_map = {
        'whole': 4.0,
        'half': 2.0,
        'quarter': 1.0,
        'eighth': 0.5,
        '16th': 0.25
    }
    return duration_map[duration_type]

class NoteProcessor:
    def __init__(self):
        self.events = []
        self.start_time_sig = None
        self.current_beat = 0.0
        self.current_key = 0
        self.tempo = 120
        self.title = 'MUSE_TITLE_TODO_REPLACEME'
        self.measure_note_mapping = {}

    def process_staves(self, root):
        staff1 = root.findall(".//Staff[@id='1']/Measure")
        staff2 = root.findall(".//Staff[@id='2']/Measure")

        for measure1, measure2 in zip(staff1, staff2):
            self.process_measure_pair(measure1, measure2)

        self.tempo = float(root.find('.//Staff/Measure/voice/Tempo/tempo').text) * 60.0
        self.title = root.find(".//Text[style='Title']/text").text

        #sort
        self.events.sort(key=lambda n: n['start_beat'])
        return {
            'events': self.events,
            'start_time_sig': self.start_time_sig,
            'key_sig': self.current_key,
            'tempo': self.tempo,
            'title': self.title,
            }

    def preprocess_measure_accidentals(self, measure):
        self.measure_note_mapping = {}
        for note in measure.findall('.//Note'):
            if note.find('Accidental') is None:
                continue
            pitch = get_pitch_from_note(note)
            if 'Sharp' in note.find('Accidental').find('subtype').text:
                self.measure_note_mapping[pitch%12] = PREFER_SHARP[pitch%12]
            if 'Flat' in note.find('Accidental').find('subtype').text:
                self.measure_note_mapping[pitch%12] = PREFER_FLAT[pitch%12]


    def process_measure_pair(self, measure1, measure2):
        saved_beat = self.current_beat
        if 'len' in measure1.attrib:
            num, denom = map(int, measure1.attrib['len'].split('/'))
            eighths_in_measure = 8 * num / denom
            self.events.append({
                'start_beat': self.current_beat,
                'eighths_in_measure': eighths_in_measure
            })
        self.preprocess_measure_accidentals(measure1)
        for voice_num, voice in enumerate(measure1.findall('voice')):
            new_beat = self.process_voice(voice, saved_beat, voice_num)
            self.current_beat = max(new_beat, self.current_beat)
        self.preprocess_measure_accidentals(measure2)
        for voice_num, voice in enumerate(measure2.findall('voice'), 2):
            new_beat = self.process_voice(voice, saved_beat, voice_num)
            self.current_beat = max(new_beat, self.current_beat)

    def process_voice(self, voice, beat, voice_num):
        keychange = voice.find('KeySig')
        if keychange:
            self.current_key = int(keychange.find('accidental').text)

        for elem in voice:
            if elem.tag == 'Chord':
                duration = self.process_chord(elem, beat, voice_num)
                beat += duration
            elif elem.tag == 'TimeSig':
                if voice_num != 0:
                    continue
                if not self.start_time_sig:
                    self.start_time_sig = (int(elem.find('sigN').text), int(elem.find('sigD').text))
                self.events.append({
                    'start_beat': self.current_beat,
                    'time_sig': (int(elem.find('sigN').text), int(elem.find('sigD').text))
                })
            elif elem.tag == 'location':
                fraction = elem.find('fractions')
                num, denom = map(int, fraction.text.split('/'))
                beat += 4.0 * num / denom
            elif elem.tag == 'Rest':
                duration = self.get_chord_duration(elem)
                beat += duration
        return beat

    def process_chord(self, chord, current_beat, voice_num):
        duration = self.get_chord_duration(chord)
        notes = self.extract_chord_details(chord)
        p = {
            'soprano': None,
            'alto': None,
            'tenor': None,
            'bass': None
        }

        if voice_num == 0:
            p['soprano'] = notes[0] if len(notes) > 0 else None
            p['alto'] = notes[1] if len(notes) > 1 else None
        if voice_num == 1:
            p['alto'] = notes[0] if len(notes) > 0 else None
        if voice_num == 2:
            p['tenor'] = notes[0] if len(notes) > 0 else None
            p['bass'] = notes[1] if len(notes) > 1 else None
        if voice_num == 3:
            p['bass'] = notes[0] if len(notes) > 0 else None

        for part, note in p.items():
            if note is not None:
                self.events.append({
                    'start_beat': current_beat,
                    'part': part,
                    'note': note,
                    'duration': duration,
                })
        return duration

    def get_chord_duration(self, chord):
        duration_type = chord.find('durationType').text
        duration = get_duration_in_beats(duration_type)
        if chord.find('dots') is not None:
            duration *= 1.5
        return duration



    def pitch_to_name(self, pitch, acc):
        name=''
        while pitch < 48:
            name += ','
            pitch += 12
        while pitch > 59:
            name += "'"
            pitch -= 12
        pitch -= 48
        if pitch in self.measure_note_mapping:
            return self.measure_note_mapping[pitch%12] + name
        return acc[pitch] + name

    def extract_chord_details(self, chord):
        n = []
        for note in chord.findall('Note'):
            acc = PREFER_BAL
            pitch = get_pitch_from_note(note)
            if self.current_key > 0:
                acc = PREFER_SHARP
            elif self.current_key < 0:
                acc = PREFER_FLAT
            accidental = note.find('Accidental')
            if accidental:
                accidental = accidental.find('subtype').text
                if 'Flat' in accidental:
                    acc = FORCE_FLAT
                elif 'Sharp' in accidental:
                    acc = FORCE_SHARP
            name = self.pitch_to_name(pitch, acc)
            spanners = self.check_spanners(chord, note)

            n.append({
                'pitch': pitch,
                'name': name,
                **spanners
            })

        n.sort(key=lambda n: n['pitch'], reverse=True)
        return n

    def check_spanners(self, chord, note):
        start_slur = chord.find("Spanner[@type='Slur']/next") is not None or note.find("Spanner[@type='Slur']/next") is not None
        start_tie = chord.find("Spanner[@type='Tie']/next") is not None or note.find("Spanner[@type='Tie']/next") is not None
        end_slur = chord.find("Spanner[@type='Slur']/prev") is not None or note.find("Spanner[@type='Slur']/prev") is not None
        end_tie = chord.find("Spanner[@type='Tie']/prev") is not None or note.find("Spanner[@type='Tie']/prev") is not None
        return {
            'start_slur': start_slur,
            'end_slur': end_slur,
            'start_tie': start_tie,
            'end_tie': end_tie,
            'start_phrasing_slur': ( start_slur or start_tie ) and ( chord.find("Spanner[@type='Tie']/Tie/lineType") is not None or note.find("Spanner[@type='Tie']/Tie/lineType") is not None or chord.find("Spanner[@type='Slur']/Slur/lineType") is not None or note.find("Spanner[@type='Slur']/Slur/lineType") is not None),
        }

def process_mscx(file_path):
    tree = ET.parse(file_path)
    processor = NoteProcessor()
    return processor.process_staves(tree.getroot())

duration_names = {
        6: '1.',
        4: '1',
        3: '2.',
        2: '2',
        1.5: '4.',
        1: '4',
        .5: '8',
        .75: '8.',
        .25: '16',
        .375: '16.',
        .125: '32',
    }

def write_ly(file_data, output_file):
    default_beats_in_measure = 4.0 * file_data['start_time_sig'][0] / file_data['start_time_sig'][1]
    in_phrasing_slur = False

    key_sig_map = {
        0: 'c',
        1: 'g',
        2: 'd',
        3: 'a',
        4: 'e',
        5: 'b',
        6: 'fs',
        -1: 'f',
        -2: 'bf',
        -3: 'ef',
        -4: 'af',
        -5: 'df',
        -6: 'gf',
    }

    DBG = True
    with open(output_file, 'w', newline='') as f:
        f.write("% This file fragment was generated by from-muse.py\n")
        #remove the first word of the title if it contains a number
        title = file_data['title']
        if title.split(' ', 1)[0][1].isdigit():
            title = title.split(' ', 1)[1]
            f.write("% Original title: " + file_data['title'] + "\n")
        f.write("title = \\titleText \"" + title + "\"\n")
        f.write("hymnKey = \\key " + key_sig_map[file_data['key_sig']] + " \\major\n")
        time = file_data['start_time_sig']
        f.write("hymnTime = \\time " + str(time[0]) + "/" + str(time[1]) + "\n")
        if time[1] == 8:
            f.write('hymnBaseMoment = \\set Timing.baseMoment = #(ly:make-moment 1/8)\n')
            if time[0] % 3 == 0:
                f.write('hymnBeatStructure = \\set Timing.beatStructure = 3,3\n')
        f.write("quarternoteTempo = " + str(int(file_data['tempo'])) + "\n")
        f.write("\\include \"../../lib/global-parts.ily\"\n")
        f.write("\\include \"../../lib/header.ily\"\n")
        f.write("\n")

        for part in ['soprano', 'alto', 'tenor', 'bass']:
            beat = 0
            beats_left_in_measure = default_beats_in_measure
            f.write(part)
            f.write(' = { \\globalParts\n')
            for n in file_data['events']:
                if 'part' in n and n['part'] != part:
                    continue
                if DBG:
                    print(n)
                while beat < n['start_beat']:
                    # insert a rest before the next note
                    missing = n['start_beat'] - beat
                    if DBG:
                        print(" ^^ Missing " + str(missing) + " beats before that note, inserting rest(s)")
                    if beats_left_in_measure == 0:
                        f.write('| ')
                        beats_left_in_measure = default_beats_in_measure
                        if DBG:
                            print("Inserted barline")
                    for d in duration_names.keys():
                        if d <= missing and d <= beats_left_in_measure:
                            f.write('r' + duration_names[d])
                            f.write(' ')
                            beat += d
                            beats_left_in_measure -= d
                            if DBG:
                                print("    Inserted rest of duration " + str(d) + ". New beat " + str(beat))
                            break
                    if beats_left_in_measure == 0:
                        f.write('| ')
                        beats_left_in_measure = default_beats_in_measure
                        if DBG:
                            print("Inserted barline")
                if beat > n['start_beat']:
                    raise Exception("Beat mismatch: We're at " + str(beat) + ", and the note wants " + str(n['start_beat']) + " in the " + part + " part. Note is " + str(n))

                if 'eighths_in_measure' in n:
                    beats_left_in_measure = n['eighths_in_measure'] / 2.0
                    if part == 'soprano':
                        f.write('\\partial 8*' + str(int(n['eighths_in_measure'])) + ' ')
                    if DBG:
                        print("Starting measure of duration " + str(beats_left_in_measure))
                    continue
                elif 'time_sig' in n:
                    default_beats_left_in_measure = 4.0 * n['time_sig'][0] / n['time_sig'][1]
                    beats_left_in_measure = default_beats_left_in_measure
                    if part == 'soprano':
                        f.write('\\time ' + str(n['time_sig'][0]) + '/' + str(n['time_sig'][1]) + ' ')
                    if DBG:
                        print("Changing time signature to " + str(n['time_sig']))
                    continue


                full_note = n['note']['name']
                full_note += duration_names[n['duration']]
                if n['note']['start_phrasing_slur']:
                    full_note += "\\("
                    in_phrasing_slur = True
                else:
                    if n['note']['start_slur']:
                        full_note += "("
                    if n['note']['start_tie']:
                        full_note += "~"
                if n['note']['end_slur']:
                    full_note += "\\)" if in_phrasing_slur else ")"
                    in_phrasing_slur = False
                if n['note']['end_tie']:
                    full_note += "\\)" if in_phrasing_slur else ""
                    in_phrasing_slur = False
                f.write(full_note)
                if DBG:
                    print(">> Wrote note " + full_note)

                f.write(" ")
                beat += n['duration']
                beats_left_in_measure -= n['duration']
                if DBG:
                    print("New beat " + str(beat) + ". Beats left in measure " + str(beats_left_in_measure))
                assert beats_left_in_measure >= 0, "Negative beats " + str(beats_left_in_measure) + " left in measure at beat "+ str(beat) + " for part " + part
                if beats_left_in_measure == 0:
                    f.write('| ')
                    beats_left_in_measure = default_beats_in_measure
                    if DBG:
                        print("Inserted barline")

            if part == 'soprano':
                f.write('\n\\bar "|."')
            f.write('\n}\n')


if __name__ == '__main__':
    from sys import argv
    input_file = argv[1]
    output_file = argv[2]

    file_data = process_mscx(input_file)
    write_ly(file_data, output_file)
