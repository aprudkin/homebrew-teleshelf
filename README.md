# Homebrew Tap for TeleShelf

## Install

```bash
brew tap aprudkin/teleshelf
brew install teleshelf
```

## Then install tdl (Telegram data export)

```bash
brew install iyear/tap/tdl
tdl login
```

## Usage

```bash
teleshelf add-channel -- "https://t.me/somechannel/42"
teleshelf sync -- somechannel
open ~/TeleShelf/reader/index.html
```

See [TeleShelf](https://github.com/aprudkin/TeleShelf) for full documentation.
