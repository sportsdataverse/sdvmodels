// sdvmodels hex logo: the Ensemble Battery, navy and gold.
//
//   cd data-raw/hex-logo && npm install && npm run build
//
// The hex is an isometric battery cell: navy body, gold band with the "+" printed on it, and a plain platinum
// terminal at the centre of the lid. Six small decision trees are wired into the terminal (gradient boosting: many
// trees summed into one prediction) and one tree's contribution is gold.
//
// Writes:
//   man/figures/logo.svg       1036 x 1200, every glyph converted to outline paths (renders with no fonts installed)
//   man/figures/logo.png       518 x 600, the README logo
//   data-raw/hex-logo/logo-favicon.svg / -64.png / -32.png / -16.png
//                              the small-size cut: six thick spokes, no side lettering (for a future favicon set)
//   pkgdown/favicon/*          favicon.ico (16/32/48), favicon.svg, 96/180/192/512 px PNGs, site.webmanifest
//   .github/social-card.png    1280 x 640 GitHub social preview (upload by hand: Settings -> General)
//
// Fails if any artwork falls outside the print-safe hex (30 px inside the edge at 1036 px).
import { createRequire } from "node:module";
import { mkdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const REPO = join(HERE, "..", "..");
const { Resvg } = createRequire(import.meta.url)("@resvg/resvg-js");
const FONT = { fontFiles: ["ArchivoBlack-Regular.ttf", "IBMPlexMono-SemiBold.ttf"].map((f) => join(HERE, "fonts", f)), loadSystemFonts: false, defaultFontFamily: "Archivo Black" };

// ---- geometry: 1036 x 1200 canvas, pointy-top hex; the hex IS the cube outline ----------------------------------
const W = 1036, H = 1200, CX = 518, CY = 600, R = 588, BORDER = 18, S3 = Math.sqrt(3);
const SAFE_R = R - (30 * 2) / S3;
const hexV = (r = R, cx = CX, cy = CY) => Array.from({ length: 6 }, (_, i) => { const a = Math.PI / 2 + (i * Math.PI) / 3; return [cx + r * Math.cos(a), cy - r * Math.sin(a)]; });
const pts = (v) => v.map(([x, y]) => `${x.toFixed(1)},${y.toFixed(1)}`).join(" ");
const pathOf = (p) => p.map(([x, y], i) => `${i ? "L" : "M"}${x.toFixed(1)},${y.toFixed(1)}`).join("");
const inHex = (x, y, r) => { const dx = Math.abs(x - CX), dy = Math.abs(y - CY); return dx <= (r * S3) / 2 && dy + dx / S3 <= r; };
const render = (svg, fitTo) => new Resvg(svg, fitTo ? { font: FONT, fitTo } : { font: FONT }).render();
const doc = (w, h, body, defs = "") => `<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="${w}" height="${h}" viewBox="0 0 ${w} ${h}"><defs>${defs}</defs>${body}</svg>`;

// glyph ink box, measured by rendering (the font's metrics alone don't give the ink)
function ink(text, family) {
  const s = 100, bx = 50, by = 200, img = render(doc(4000, 320, `<text x="${bx}" y="${by}" font-family="${family}" font-size="${s}" fill="#000">${text}</text>`));
  const px = img.pixels, w = img.width; let x0 = 1e9, x1 = -1, y0 = 1e9, y1 = -1;
  for (let i = 3; i < px.length; i += 4) if (px[i] > 24) { const p = (i - 3) / 4, x = p % w, y = (p / w) | 0; x0 = Math.min(x0, x); x1 = Math.max(x1, x); y0 = Math.min(y0, y); y1 = Math.max(y1, y); }
  return { w: (x1 - x0 + 1) / s, left: (x0 - bx) / s, top: (by - y0) / s, bottom: (y1 - by) / s };
}

// ---- palette ----------------------------------------------------------------------------------------------------
const P = { lid: "#1B2C57", left: "#15254C", right: "#0B1636", bandL: "#E0A526", bandR: "#B5821A", bandHi: "#FFD27A", plus: "#0B1636", sdv: "#F4F1EA", models: "#FFC857", tree: "#6A7DAB", gold: "#FFC857", border: "#060D22" };
const PLAT = `<linearGradient id="platS" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#7D838C"/><stop offset="0.3" stop-color="#F6F7F9"/><stop offset="0.6" stop-color="#C9CDD3"/><stop offset="1" stop-color="#6E747D"/></linearGradient><radialGradient id="platT" cx="0.38" cy="0.35" r="0.8"><stop offset="0" stop-color="#FFFFFF"/><stop offset="0.55" stop-color="#D9DCE1"/><stop offset="1" stop-color="#A9AEB6"/></radialGradient>`;

// lid plane (u, w) in [-294, 294]^2, centre -> (518, 306)
const L = (u, w) => [CX + (u - w) * 0.866, 306 + (u + w) * 0.5];
const Lp = (r, a) => L(r * Math.cos(a), r * Math.sin(a));
const seg = (p, col, w, extra = "") => `<path d="${pathOf(p)}" fill="none" stroke="${col}" stroke-width="${w}" stroke-linecap="round" stroke-linejoin="round" ${extra}/>`;
const dot = ([x, y], rx, col) => `<ellipse cx="${x.toFixed(1)}" cy="${y.toFixed(1)}" rx="${rx}" ry="${(rx * 0.66).toFixed(1)}" fill="${col}"/>`;
const angle = (k) => -Math.PI / 2 + (k * Math.PI) / 3 + Math.PI / 6;

// six trees around the terminal; tree 1 is the gold contribution
function ensemble() {
  let s = "";
  for (let k = 0; k < 6; k++) {
    const a = angle(k), on = k === 1, col = on ? P.gold : P.tree, sp = 0.17;
    const root = Lp(120, a), mids = [-1, 1].map((g) => Lp(175, a + g * sp)), leaves = [-1.5, -0.5, 0.5, 1.5].map((q) => Lp(240, a + q * sp * 0.9));
    s += seg([L(0, 0), root], col, on ? 10 : 7, on ? "" : 'stroke-dasharray="4 10"') + mids.map((m) => seg([root, m], col, 9)).join("") + leaves.map((lf, i) => seg([mids[i >> 1], lf], col, 8)).join("");
    s += [root, ...mids].map((p) => dot(p, 10, col)).join("") + leaves.map((p) => dot(p, 12, col)).join("");
  }
  return s;
}
// small-size cut: the same six directions as thick spokes ending in big dots
const spokes = () => Array.from({ length: 6 }, (_, k) => { const col = k === 1 ? P.gold : P.tree, end = Lp(215, angle(k)); return seg([L(0, 0), end], col, 30) + dot(end, 40, col); }).join("");

function battery(lidArt, { sides = true } = {}) {
  const v = hexV(), c = [CX, CY], bh = 150;
  const ground = `<polygon points="${pts([v[0], v[5], c, v[1]])}" fill="${P.lid}"/><polygon points="${pts([v[1], c, v[3], v[2]])}" fill="${P.left}"/><polygon points="${pts([c, v[5], v[4], v[3]])}" fill="${P.right}"/>` +
    `<polygon points="${pts([v[1], c, [c[0], c[1] + bh], [v[1][0], v[1][1] + bh]])}" fill="${P.bandL}"/><polygon points="${pts([c, v[5], [v[5][0], v[5][1] + bh], [c[0], c[1] + bh]])}" fill="${P.bandR}"/>` +
    `<polyline points="${pts([[v[1][0], v[1][1] + bh], [c[0], c[1] + bh], [v[5][0], v[5][1] + bh]])}" fill="none" stroke="${P.bandHi}" stroke-width="6"/>` +
    `<text transform="matrix(1 0.5774 0 1 0 0)" x="60" y="${306 + 92 - 60 * 0.5774 + 40}" font-family="Archivo Black" font-size="96" fill="${P.plus}">+</text>`;
  let txt = "";
  if (sides) { // 'sdv' and 'models' set in perspective on the two side faces (skewY +/-30 degrees)
    const mL = ink("sdv", "Archivo Black"), mR = ink("models", "Archivo Black"), sL = 300 / mL.w, sR = 380 / mR.w;
    const xL = 265 - 150 - mL.left * sL, yL = 790 - 265 * 0.5774 + ((mL.top - mL.bottom) / 2) * sL;
    const xR = 771 - 190 - mR.left * sR, yR = 790 + 771 * 0.5774 + ((mR.top - mR.bottom) / 2) * sR;
    txt = `<text transform="matrix(1 0.5774 0 1 0 0)" x="${xL.toFixed(1)}" y="${yL.toFixed(1)}" font-family="Archivo Black" font-size="${sL.toFixed(1)}" fill="${P.sdv}">sdv</text><text transform="matrix(1 -0.5774 0 1 0 0)" x="${xR.toFixed(1)}" y="${yR.toFixed(1)}" font-family="Archivo Black" font-size="${sR.toFixed(1)}" fill="${P.models}">models</text>`;
  }
  const nub = `<ellipse cx="${CX}" cy="306" rx="66" ry="38" fill="#3A3F48"/><rect x="${CX - 66}" y="264" width="132" height="42" fill="url(#platS)"/><ellipse cx="${CX}" cy="264" rx="66" ry="38" fill="url(#platT)"/><ellipse cx="${CX}" cy="264" rx="48" ry="27" fill="none" stroke="#9AA0A9" stroke-width="3"/>`;
  const art = lidArt + nub + txt;
  const edges = `<g stroke="#000" stroke-opacity="0.6" stroke-width="4"><line x1="${CX}" y1="${CY}" x2="${v[1][0]}" y2="${v[1][1]}"/><line x1="${CX}" y1="${CY}" x2="${v[5][0]}" y2="${v[5][1]}"/><line x1="${CX}" y1="${CY}" x2="${v[3][0]}" y2="${v[3][1]}"/></g>`;
  const clip = `<clipPath id="hexclip"><polygon points="${pts(hexV())}"/></clipPath>`;
  return {
    svg: doc(W, H, `<g clip-path="url(#hexclip)">${ground}${art}${edges}</g><polygon points="${pts(hexV())}" fill="none" stroke="${P.border}" stroke-width="${BORDER}" stroke-linejoin="round"/>`, clip + PLAT),
    art: doc(W, H, art, PLAT),
  };
}

// every inked pixel of the artwork (the faces are the ground) must sit inside the print-safe hex
function assertSafe(name, artSvg) {
  const { pixels } = render(artSvg); let bad = 0;
  for (let i = 3; i < pixels.length; i += 4) if (pixels[i] > 40) { const p = (i - 3) / 4; if (!inHex(p % W, (p / W) | 0, SAFE_R)) bad++; }
  if (bad) throw new Error(`${name}: ${bad} px of artwork outside the 30 px print-safe hex`);
}
// text -> outline paths: resvg's own serialiser writes glyphs as paths, so the SVG needs no fonts
const outline = (svg) => new Resvg(svg, { font: FONT }).toString();

const full = battery(ensemble()), cut = battery(spokes(), { sides: false });
assertSafe("logo", full.art); assertSafe("favicon cut", cut.art);
writeFileSync(join(REPO, "man/figures/logo.svg"), outline(full.svg));
writeFileSync(join(REPO, "man/figures/logo.png"), render(full.svg, { mode: "width", value: 518 }).asPng());
writeFileSync(join(HERE, "logo-favicon.svg"), outline(cut.svg));
for (const s of [64, 32, 16]) writeFileSync(join(HERE, `logo-favicon-${s}.png`), render(cut.svg, { mode: "height", value: s }).asPng());

// pkgdown favicon set, from the small-size cut: the hex centred on a square (transparent, except the opaque
// apple-touch icon, which iOS would otherwise fill with black)
{
  const dir = join(REPO, "pkgdown/favicon"); mkdirSync(dir, { recursive: true });
  const cutSquare = (bg = "") => cut.svg.replace(/^<svg[^>]*>/, `<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="1200" height="1200" viewBox="${-(1200 - W) / 2} 0 1200 1200">` + (bg ? `<rect x="${-(1200 - W) / 2}" y="0" width="1200" height="1200" fill="${bg}"/>` : ""));
  const png = (svg, s) => render(svg, { mode: "width", value: s }).asPng();
  writeFileSync(join(dir, "favicon.svg"), outline(cutSquare()));
  for (const [f, s] of [["favicon-96x96.png", 96], ["web-app-manifest-192x192.png", 192], ["web-app-manifest-512x512.png", 512]]) writeFileSync(join(dir, f), png(cutSquare(), s));
  writeFileSync(join(dir, "apple-touch-icon.png"), png(cutSquare("#0E1A3A"), 180));
  // favicon.ico: PNG-compressed entries at 16, 32 and 48 px (ICONDIR + ICONDIRENTRY headers, then the PNGs)
  const imgs = [16, 32, 48].map((s) => [s, png(cutSquare(), s)]);
  const head = Buffer.alloc(6 + 16 * imgs.length); head.writeUInt16LE(0, 0); head.writeUInt16LE(1, 2); head.writeUInt16LE(imgs.length, 4);
  let off = head.length;
  imgs.forEach(([s, b], i) => { const e = 6 + 16 * i; head[e] = s; head[e + 1] = s; head.writeUInt16LE(1, e + 4); head.writeUInt16LE(32, e + 6); head.writeUInt32LE(b.length, e + 8); head.writeUInt32LE(off, e + 12); off += b.length; });
  writeFileSync(join(dir, "favicon.ico"), Buffer.concat([head, ...imgs.map(([, b]) => b)]));
  writeFileSync(join(dir, "site.webmanifest"), JSON.stringify({ name: "sdvmodels", short_name: "sdvmodels", icons: [192, 512].map((s) => ({ src: `/web-app-manifest-${s}x${s}.png`, sizes: `${s}x${s}`, type: "image/png", purpose: "maskable" })), theme_color: "#0E1A3A", background_color: "#0E1A3A", display: "standalone" }, null, 2) + "\n");
}

// social card: hex left, wordmark and tagline right, inside GitHub's 40 px margin
{
  const hexPng = render(full.svg, { mode: "width", value: 518 }).asPng(), hexH = 520, hexW = (hexH * W) / H, hx = 70, hy = 60, tx = 590;
  const m = ink("sdvmodels", "Archivo Black"), size = Math.min(600 / m.w, 130 / (m.top + m.bottom)), tTop = 190, base = tTop + m.top * size, tBot = tTop + (m.top + m.bottom) * size;
  const body = `<rect width="1280" height="640" fill="#0E1A3A"/>` +
    `<polygon points="${pts(hexV(hexH / 2 - 6, hx + hexW / 2, hy + hexH / 2 + 10))}" fill="#000" fill-opacity="0.45" filter="url(#sh)"/>` +
    `<image x="${hx}" y="${hy}" width="${hexW.toFixed(1)}" height="${hexH}" xlink:href="data:image/png;base64,${hexPng.toString("base64")}"/>` +
    `<text x="${(tx - m.left * size).toFixed(1)}" y="${base.toFixed(1)}" font-family="Archivo Black" font-size="${size.toFixed(1)}" fill="#F4F1EA">sdvmodels</text>` +
    `<rect x="${tx}" y="${tBot + 36}" width="64" height="6" rx="3" fill="${P.gold}"/>` +
    `<text x="${tx}" y="${tBot + 102}" font-family="IBM Plex Mono" font-weight="600" font-size="34" fill="#F4F1EA">Fitted models. Installed once.</text>` +
    `<rect x="${tx}" y="${tBot + 140}" width="450" height="52" rx="26" fill="none" stroke="#F4F1EA" stroke-opacity="0.35" stroke-width="2"/>` +
    `<text x="${tx + 26}" y="${tBot + 174}" font-family="IBM Plex Mono" font-weight="600" font-size="22" fill="#F4F1EA" fill-opacity="0.85">sportsdataverse / sdvmodels</text>`;
  writeFileSync(join(REPO, ".github/social-card.png"), render(doc(1280, 640, body, `<filter id="sh" x="-30%" y="-30%" width="160%" height="160%"><feGaussianBlur stdDeviation="18"/></filter>`)).asPng());
}
console.log("wrote man/figures/logo.{svg,png}, pkgdown/favicon/*, .github/social-card.png and the favicon cut");
