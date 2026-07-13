// Quick test of URL generation logic
const testState = {
  input: 'K: D\nD E F G',
  speed: 1.0,
  metronomeVol: 50,
  pianoVol: 80,
  hasUrlPayload: false
};

// Simulate the logic
const origin = 'http://localhost:3000';
const pathname = '/index.html';
const base = pathname;
const url = new URL(base, origin);
url.searchParams.set('state', 'test-encoded-state');
console.log('Generated URL:', url.toString());
