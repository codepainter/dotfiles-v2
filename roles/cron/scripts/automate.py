import os
from pathlib import Path
import re
import shutil
import pprint

pp = pprint.PrettyPrinter(indent=4)

WATCH_FOLDERS = [
    "/Volumes/Seagate2TB/done",
    "/Volumes/home/HTemp (unsorted)",
]
WATCH_EXTENSION = ".cbz"
DESTINATION = "/Volumes/home/Temporarily"
# REGEX
BRACKETS = re.compile(r'\[(.*?)\]')
HANGUL = re.compile(u'[\u3131-\ucb4c]')
KOREAN = re.compile(r'[\u3131-\u314e|\u314f-\u3163|\uac00-\ud7a3]')
CHINESE = re.compile(r'[\u4e00-\u9FFF]')
JAPANESE = re.compile(r'[\u3040-\u30ff]')
SPECIAL_CHARS = re.compile(r':|♥|é|ō|&|[äöüÄÖÜß]')


def list_cbz_files(path: Path) -> list[Path]:
    # return list of cbz files in path
    return [f for f in path.iterdir() if f.is_file() and f.suffix == WATCH_EXTENSION]


def count_cbz_files(path: Path) -> int:
    # return number of cbz files in path, and list of cbz files
    return len(list_cbz_files(path))


def list_dir(path: Path) -> list[Path]:
    # return list of directories in path
    return [f for f in path.iterdir() if f.is_dir()]


def count_dir(path: Path) -> int:
    # return number of directories in path
    return len(list_dir(path))


def zip_to_cbz(path: str) -> None:
    # Ensure path is a directory
    _path = Path(path)
    if not _path.is_dir():
        raise ValueError(f"{path} is not a directory")
    # Zip directory
    absolute_dir_path = _path.absolute()
    print(f"Zipping {absolute_dir_path}")
    shutil.make_archive(f"{absolute_dir_path}", 'zip', f"{absolute_dir_path}")
    # Rename zip to cbz
    cbz_filename = f"{absolute_dir_path}.cbz"
    os.rename(f"{absolute_dir_path}.zip", cbz_filename)
    # Delete directory
    shutil.rmtree(f"{absolute_dir_path}")


def main():
    move_count = 0
    destination_folder_exists = False
    # check if destination folder exists
    if os.path.exists(DESTINATION):
        destination_folder_exists = True

    for watch_folder in WATCH_FOLDERS:
        if not os.path.exists(watch_folder):
            pp.pprint(f"Watch folder {watch_folder} not found")
            continue

        watch_folder_path = Path(watch_folder)
        directory_count = count_dir(watch_folder_path)
        pp.pprint(f"Found {directory_count} directories in {watch_folder}")
        directory_list = list_dir(watch_folder_path)
        pp.pprint(directory_list)

        for directory in directory_list:
            zip_to_cbz(directory)

        cbz_count = count_cbz_files(watch_folder_path)
        pp.pprint(f"Found {cbz_count} cbz files in {watch_folder}")
        cbz_list = list_cbz_files(watch_folder_path)
        pp.pprint(cbz_list)

        for cbz_file in cbz_list:

            # check if cbz_file has special chars, then skip
            if re.search(SPECIAL_CHARS, cbz_file.name):
                print(
                    f"Special characters found in {cbz_file.name}. Skipping...")
                continue

            # check if cbz_file has chinese, then skip
            if re.search(CHINESE, cbz_file.name):
                print(
                    f"Chinese characters found in {cbz_file.name}. Skipping...")
                continue

            # check if file has square brackets
            match = re.search(BRACKETS, cbz_file.stem)
            if match is None:
                print(f"No match found in {cbz_file.name}. Skipping...")
                continue

            # add square brackets back
            match = f"[{match.group(1)}]"

            print(f"Matched {match} in {cbz_file.name}")
            # check if destination folder, and match folder exists
            match_folder = Path(f"{DESTINATION}/{match}").absolute()
            if destination_folder_exists and not os.path.exists(match_folder):
                os.makedirs(match_folder)

            # move file
            if destination_folder_exists:
                shutil.move(cbz_file.absolute(),
                            f"{match_folder}/{cbz_file.name}")
                print(f"Moved {cbz_file.name} to {match_folder}")
                move_count += 1

    print(f"Moved {move_count} files")


if __name__ == "__main__":
    main()
