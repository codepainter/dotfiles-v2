import os
from pathlib import Path
import re
import shutil
from rich.console import Console
from mapping import regex_dict
from hurry.filesize import size
from py7zr import unpack_7zarchive

shutil.register_unpack_format("7zip", [".7z"], unpack_7zarchive)
console = Console()

WATCH_FOLDERS = [
    "/Volumes/Seagate2TB/JDownloader/Various Files",
]
WATCH_EXTENSIONS = [".zip", ".rar", ".7z"]
WATCH_VIDEO_EXTENSIONS = [".mp4"]
DESTINATION = "/Volumes/home/H3D"
BACKUP_DESTINATION = "/Volumes/Seagate2TB/H3D"


def check_dest_dir(dir_path: Path):
    if not dir_path.exists():
        dir_path.mkdir(parents=True)


def unzip_file(file: Path, destination: Path) -> None:
    # Ensure file is a file
    if not file.is_file():
        raise ValueError(f"{file} is not a file")
    # ensure destination is a directory
    if not destination.is_dir():
        raise ValueError(f"{destination} is not a directory")
    with console.status(f"Unzipping {file.name}..."):
        # Unzip file
        shutil.unpack_archive(file.absolute(), destination.absolute())
        # Delete file
        file.unlink()
        console.log(f"Unzipped {file.name} ...Done!")


def move_file(abs_src: Path, abs_dest: Path) -> None:
    # ensure source is a file
    if not abs_src.is_file():
        raise ValueError(f"{abs_src} is not a file")
    with console.status(f"move_file(): {abs_src.stem} to {abs_dest.parent}..."):
        check_dest_dir(abs_dest.parent)
        file_size = os.path.getsize(abs_src)
        shutil.move(abs_src, abs_dest)
        console.log(f"Moved {abs_src} ({size(file_size)}) ...Done!")


def move_dir(src_path: Path, dest_path: Path) -> None:
    if src_path.is_dir():
        for items in src_path.iterdir():
            move_dir(items, dest_path / items.name)
    else:
        if src_path.name == ".DS_Store":
            return
        move_file(src_path, dest_path)


def main():
    unzip_count = 0
    _h3d_dest = DESTINATION
    # check if destination folder exists
    if not Path(DESTINATION).exists():
        _h3d_dest = BACKUP_DESTINATION
        if not Path(BACKUP_DESTINATION).exists():
            console.log(
                f"Destination folder {DESTINATION} and backup folder {BACKUP_DESTINATION} not found"
            )
            return

    for folder_path in WATCH_FOLDERS:
        path = Path(folder_path)
        if not path.exists():
            console.log(f"Watch folder {path} not found")
            continue
        for file in path.iterdir():
            if file.suffix not in WATCH_EXTENSIONS:
                continue
            # match filename with regex from h3d_mapping.py
            for regex, destination in regex_dict.items():
                if not re.search(regex, file.name):
                    continue
                dest_path = Path(f"{_h3d_dest}/{destination}")
                # check if destination folder exists
                check_dest_dir(dest_path)
                unzip_file(file, dest_path)
                unzip_count += 1
                break
    console.log(f"Unzipping {unzip_count} Done!")


def move_folder():
    # check if DESTINATION exists
    if not Path(DESTINATION).exists():
        console.log(f"move(): Destination folder {DESTINATION} not found")
        return
    # for each folder in BACKUP_DESTINATION
    for folder_path in Path(BACKUP_DESTINATION).iterdir():
        # match folder name with regex from h3d_mapping.py
        for regex, destination in regex_dict.items():
            if not re.search(regex, folder_path.name):
                continue
            dest_path = Path(f"{DESTINATION}/{destination}")
            check_dest_dir(dest_path)
            move_dir(folder_path, dest_path)
            # remove empty folder
            shutil.rmtree(folder_path)
    console.log(f"Moving Folders Done!")


def move_files():
    # check if DESTINATION exists
    if not Path(DESTINATION).exists():
        console.log(f"move(): Destination folder {DESTINATION} not found")
        return
    # for each folder in WATCH_FOLDERS
    for folder_path in WATCH_FOLDERS:
        # for each video files in folder_path
        for file in Path(folder_path).iterdir():
            if file.suffix not in WATCH_VIDEO_EXTENSIONS:
                continue
            # match filename with regex from h3d_mapping.py
            for regex, destination in regex_dict.items():
                if not re.search(regex, file.name):
                    continue
                dest_path = Path(f"{DESTINATION}/{destination}")
                # check if destination folder exists
                check_dest_dir(dest_path)
                move_file(file, dest_path / file.name)
                break

    console.log("Moving Files Done!")


if __name__ == "__main__":
    main()
    move_folder()
    move_files()
