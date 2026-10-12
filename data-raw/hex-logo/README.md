# sdvmodels hex logo

`hex-logo.mjs` draws the package's hex logo, its small-size cut and the GitHub social card.

```sh
cd data-raw/hex-logo
npm install
npm run build
```

It needs Node and `@resvg/resvg-js` (the only dependency, pinned in `package.json`), and loads the two fonts in
`fonts/` explicitly, so the output does not depend on what is installed on the machine.

## What it writes

| File | Size | Use |
| --- | --- | --- |
| `man/figures/logo.svg` | 1036 x 1200 | master; every glyph converted to outline paths, so it renders with no fonts installed |
| `man/figures/logo.png` | 518 x 600 | README logo |
| `data-raw/hex-logo/logo-favicon.svg`, `-64/-32/-16.png` | | small-size cut for a future favicon set (64 px and below) |
| `.github/social-card.png` | 1280 x 640 | GitHub social preview; GitHub has no API for it, so upload it under Settings -> General |

The script fails if any artwork falls outside the print-safe hex, 30 px inside the edge at 1036 px.

## The design

The hex is drawn as an isometric battery cell: a navy body (`#15254C` / `#0B1636`, lid `#1B2C57`), a gold band
(`#E0A526` / `#B5821A`) with the `+` printed on it, and a plain platinum terminal at the centre of the lid. Six
small decision trees are wired into the terminal, because the package's models are gradient-boosted trees: many trees
summed into one prediction. One tree's contribution is gold (`#FFC857`). `sdv` and `models` are set in perspective on
the two side faces in Archivo Black.

The favicon cut replaces the six trees with six thick spokes, one gold, and drops the side lettering, which cannot be
read below about 64 px.

## Fonts

Both fonts are under the SIL Open Font License 1.1; the licence texts sit next to them and must travel with them.

- Archivo Black, by the Archivo Black Project Authors (`fonts/OFL-ArchivoBlack.txt`)
- IBM Plex Mono SemiBold, by IBM Corp. (`fonts/OFL-IBMPlexMono.txt`), used only on the social card
