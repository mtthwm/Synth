from sys import argv

NOTE_MAP = {
    "RE": 0,
    "A4": 1,
    "B4": 2,
    "C4": 3,
    "D4": 4,
    "E4": 5,
    "F4": 6,
    "G4": 7,
    "A5": 8,
    "B5": 9,
    "C5": 10,
    "D5": 11,
    "E5": 12,
    "F5": 13,
    "G5": 14,
    "A6": 15
}

melody = []
with open(argv[1], 'r') as input_file:
    for line in input_file:
        str_notes = line.split()
        notes = []
        for sn in str_notes:
            notes.append(NOTE_MAP[sn])
        melody.append(notes)

with open(argv[2], 'w') as output_file:
    output_file.write("@0\n")
    for notes in melody:
        for note in notes:
            output_file.write(hex(note).replace("0x", ""))
        output_file.write('\n')