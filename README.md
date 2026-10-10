# R2Thunder
A tool to interface with the R2 file structure of Thunder games.

Written by AxlThunder in Game Maker 8.2. **No AI is used for any part of this project, and it will stay that way.**

This project currently uses the following GM82 extensions:
* 8.2 Core
* 8.2 DirectX9
* 8.2 Network(for the buffer_ functions used in file reading/writing)

This tool can interface with R2s of the following:
* Hydro Thunder(Arcade and Dreamcast)
* Offroad Thunder(Arcade)

It can read the file directory, browse it, filter it, search it, and extract any asset. As of this time, everything but textures and sounds of known formats are extracted raw, with their reftable. Known textures can be exported to BMP format, and known sounds can be exported to WAV format. Dreamcast PVRs can be detected, but they can only be extracted raw. Current efforts and documentation are primarily focused on the original arcade version.

Modification, unpacking, and repacking is not implemented at this time, but is a goal.


# Hotkeys
* Page Up/Down: Fastest way of scrolling the file list for right now.
* Home: Jump to the beginning of the file list.
* End: Jump to the end of the file list.
* Ctrl + Left/Right: If having searched for a file previously, this finds the previous/next file, respectively.
* Ctrl + F: Shortcut to file search.
* Ctrl + G: Shortcut to file number jump.


# Known Issues
- Many Dreamcast assets don't extract with a proper data and reftable split, due to the data>reftable order in many of the files being flipped around.
- Offroad Thunder uses the same file type (0x44) for other kinds of assets, and as a result, for the time being, the tool labels them all under Demo Reel Data.


# To-do:
- UI QoL
- CSH file support
- bulk extracting all of the files in the currently shown filter
- file replacement and adding


# Technical Details
Efforts to document this format are still ongoing, so the information below is subject to additions and changes.

The R2 is a WAD like format. The header, in true Hydro Thunder developer fashion, begins with James Cameron Rules. R2Thunder uses this to verify the file being opened is an R2. At 0x2C is the total number of files it contains. For example, HT.R2, the R2 from the original arcade version of Hydro Thunder, has 4,558 files. The file directory begins at 0x200000, and the file data begins at 0x800000. R2Thunder begins reading from 0x1FFFF4, for string alignment reasons. Each file entry, except for the very first, begins with 12 bytes whose purpose aren't yet known, followed by the file's location(4 bytes), the file's size(4 bytes), the number of reference table entries(4 bytes), the name of the file(11 bytes, plain text), and a plain text name, which is also seen twice at the very beginning of the file.


## The R2 RefTable
The reference table, each entry being 16 bytes long, contains the names of other assets in the R2 that particular file uses, such as a model calling for textures. World data will not only call for textures, but the models used besides the track itself. At this time, the reference table isn't fully understood.


## The R2 File Header
Every file in the R2 has a header that is specific to this format. It can vary in size, depending on the type of file that is present. For textures, it can either be 0x14 or 0x28 bytes in size. Every file always begins with the size in hex(3 bytes), followed by the file's type(1 byte). Uncompressed sound file headers are 8 bytes in size, with the last 4 being the sample data size.


## Current known file types
* 0x41: animation data
* 0x42, 0x4D, 0x54: textures
* 0x44: demo mode data
* 0x47: models
* 0x48: world data
* 0x4B: compressed sound archive??
* 0x50: physics parameters file
* 0x52: files of unknown format, but they appear to be radar maps
* 0x53: sound data


## Known texture types
* 16-bit color depth, 15 bits color, 1 bit alpha. uncompressed
* 16-bit color depth, 12 bits color, 4 bits alpha. uncompressed
* Unknown at this time, but used for every texture whose name contains "9" as the second to last character in the name. appears to be compressed

## What world data is known to contain
* track visual and collision models
* boat start positions
* water path data
* object placement
