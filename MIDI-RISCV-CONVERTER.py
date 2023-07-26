import os
import sys
import platform as p
FOLDER_PATH = os.path.dirname(os.path.realpath(__file__))

input_path = FOLDER_PATH + '\\' + sys.argv[1]

if not os.path.isfile(input_path):
    print (input_path)
    raise Exception("ERROR: The input path is doesn't exist.")
if not input_path.endswith(".mid"):
    raise Exception("ERROR: The given file isn't .mid")

from mido import MidiFile
from mido import tick2second
mid = MidiFile(input_path)
filename = sys.argv[1].split("/")[-1].replace(".mid", ".data")

with open(filename, "w") as f:
    name = filename.replace(".data", "").replace("-", "_").upper()
    print(name)
    for i, track in enumerate(mid.tracks):
        nlista = []
        plista = []
        for msg in track:
            if (not msg.is_meta and (msg.type == 'note_on' or msg.type == 'note_off')):
                nlista.append(msg.note)
                plista.append(int((tick2second(msg.time, mid.ticks_per_beat,tempo)*1000)))
            if msg.type == 'set_tempo':
                tempo = msg.tempo
        
        count = 0
        currenttrack = ''
        for j in range(len(nlista)):
            if (plista[j] == 0):
                continue
            if (j == 1):
                currenttrack += str(nlista[j]) + ", " + str(plista[j])
            else:
                currenttrack += ", " + str(nlista[j]) + ", " + str(plista[j])
            count += 1
        currenttrack = f"{name}_TRACK{i}_SIZE: .word {count}\n{name}_TRACK{i}_NOTES: {currenttrack} \n\n"
        f.write(currenttrack)

print("Done!")