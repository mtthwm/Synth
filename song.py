from sys import argv

NOTE_MAP = {
    "RE": 0,
    "A3": 1,
    "B3": 2,
    "C4": 3,
    "D4": 4,
    "E4": 5,
    "F4": 6,
    "G4": 7,
    "A4": 8,
    "B4": 9,
    "C5": 10,
    "D5": 11,
    "E5": 12,
    "F5": 13,
    "G5": 14,
    "A5": 15
}

active_channel = 0
chan_notes = ([], [], [], [])

with open(argv[1], 'r') as input_file:
    for line in input_file:
        if line.startswith("#"):
            active_channel = int(line[1:])
        elif line.strip():
            note_num = NOTE_MAP[line.strip()]
            chan_notes[active_channel].append(note_num)

def d2h (dec):
    return hex(dec).replace("0x", "")[0]

with open(argv[2], 'w') as output_file:
    output_file.write("@0\n")
    for i in range(len(chan_notes[0])):
        line = f"{d2h(chan_notes[0][i])}{d2h(chan_notes[1][i])}{d2h(chan_notes[2][i])}{d2h(chan_notes[3][i])}\n"
        output_file.write(line)            