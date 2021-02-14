#! /usr/bin/env python3
import sys
import json
from os import path, system
from math import fabs
import shutil
import glob
import datetime


CONFIG_FILE = '/home/adam/.dotfiles/sort_lectures/config.json'


def read_config():

    with open(CONFIG_FILE, 'r') as config_file:
        config = config_file.read()
        config = json.loads(config)
        return config


def main():
    type_of_class = {
        'W': 'Wykład',
        'C': 'Ćwiczenia',
        'L': 'Laby',
        'P': 'Projekty'
    }
    week = {
        0: 'Pn',
        1: 'Wt',
        2: 'Sr',
        3: 'Czw',
        4: 'Pt',
        5: 'Sob',
        6: 'Nd'
    }

    if path.exists(CONFIG_FILE):
        config = read_config()
    else:
        config = {}

    if len(sys.argv) > 1 and sys.argv[1] == 'add':
        if len(sys.argv) < 6:
            sys.stderr.write('Not enough arguments!\n'
                             'main.py add [name] [start time] [day] [type]\n')
            exit(1)
        time = int(sys.argv[3].split(':')[0]) * 60 + \
               int(sys.argv[3].split(':')[1])

        class_data = {'name': sys.argv[2],
                      'start': time,
                      'day': sys.argv[4],
                      'type': sys.argv[5]}

        if config:
            config['classes'].append(class_data)
        else:
            config['path'] = '/home/adam/AGH/III_SEMESTR/'
            config['classes'] = [class_data]

        with open(CONFIG_FILE, 'w') as config_file:
            config_file.write(json.dumps(config))
        exit(0)

    elif not config and (len(sys.argv) == 1 or sys.argv[1] != 'add'):
        sys.stderr.write('No config file found!\nAdd classes first!\n')
        exit(1)

    else:
        new_video = path.basename(sys.argv[1])

        new_video_time = new_video.split('.')[0].split(' ')[1]


        vid_time = int(new_video_time.split('-')[0]) * 60 + \
                   int(new_video_time.split('-')[1])

        date = new_video.split(' ')[0]

        day = datetime.datetime(int(date.split('-')[0]),
                                int(date.split('-')[1]),
                                int(date.split('-')[2])).weekday()

        for lecture in config['classes']:

            if abs(int(vid_time) - int(lecture['start'])) < 30 and week[day] == lecture['day']:
                print(int(vid_time) - int(lecture['start']))
                print(abs(int(vid_time) - int(lecture['start'])))
                print(vid_time, lecture['start'], '\n', week[day], lecture['day'], end='\n\n')
                new_path = f'{config["path"]}/{lecture["name"]}'
                files_in_dir = glob.glob(f'{new_path}/{type_of_class[lecture["type"]]}*')
                new_name = f'{new_path}/{type_of_class[lecture["type"]]} {len(files_in_dir) + 1}.mkv'
                shutil.copyfile(sys.argv[1], new_name)
                shutil.move(sys.argv[1], f'{path.dirname(sys.argv[1])}/Moved')
                system("notify-send 'OBSRecords' '{}' --icon=dialog-information".format(new_name))


if __name__ == '__main__':
    main()
