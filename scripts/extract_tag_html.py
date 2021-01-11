#!/usr/bin/env python3
import sys

def get_tags(all_lines):
    for i, line in enumerate(all_lines):
        line = line.strip()
        if line.replace(" ", "").startswith('tags="'):
            tag_string = line[line.index('"')+1:-1]
            tags = tag_string.split()
            for t in tags:
                print('<a class="taglink" href="{{ site.baseurl }}/tag_listing/'+t+'.html">')
                print(t)
                print('</a>')
            return

if __name__ == "__main__":
    with open(sys.argv[1], 'r') as f:
        get_tags(f.readlines())
