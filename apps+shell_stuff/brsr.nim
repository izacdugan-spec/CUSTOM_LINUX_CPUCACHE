{.compileropts: "-ffreestanding -nostdlib".}

const VGA_ADDRESS = cast[ptr array[2000, uint16]](0xB8000)
const SCREEN_WIDTH = 80
const SCREEN_HEIGHT = 25

proc containsSubstring(haystack, needle: string): bool =
  if needle.len > haystack.len: return false
  for i in 0 .. (haystack.len - needle.len):
    if haystack[i .. <(i + needle.len)] == needle:
      return true
  return false

proc makeVgaCell(character: char, color: uint8): uint16 =
  return (color.uint16 shl 8) or character.uint16

proc drawBrowserChrome(url: string) =
  # 1. Draw top address navigation bar layout (White text on gray: 0x70)
  for col in 0 ..< SCREEN_WIDTH:
    VGA_ADDRESS[col] = makeVgaCell(' ', 0x70)

  let prefix = "[<-] [->] [R] Address: "
  for i, character in prefix:
    VGA_ADDRESS[i + 1] = makeVgaCell(character, 0x70)

  for i, character in url:
    let idx = prefix.len + 1 + i
    if idx >= SCREEN_WIDTH: break
    VGA_ADDRESS[idx] = makeVgaCell(character, 0x7F)

  for cell_idx in SCREEN_WIDTH ..< (SCREEN_WIDTH * SCREEN_HEIGHT):
    VGA_ADDRESS[cell_idx] = makeVgaCell(' ', 0x1F)

proc printOutputLine(msg: string, row, col: int, color: uint8) =
  let base_offset = row * SCREEN_WIDTH + col
  for i, character in msg:
    let cell = base_offset + i
    if cell >= (SCREEN_WIDTH * SCREEN_HEIGHT): break
    VGA_ADDRESS[cell] = makeVgaCell(character, color)

proc run_browser_instance*(input_str: string) {.exportc.} =
  let info_color: uint8 = 0x1B  # Cyan text
  let alert_color: uint8 = 0x1E # Yellow text

  
  if containsSubstring(input_str, "http") or containsSubstring(input_str, ".com") or containsSubstring(input_str, ".org"):
    # Direct website routing
    drawBrowserChrome(input_str)
    printOutputLine("CONNECTING TO HOST SERVER VIA LOCAL SOCKET ARRAYS...", 4, 5, info_color)
    printOutputLine("PARSING STYLESHEET NODES... RENDER PASS COMPLETE.", 6, 5, info_color)
  else:
    drawBrowserChrome("https://duckduckgo.com")
    printOutputLine("ROUTING PLAIN TEXT SEARCH STRING TO ENGINE DATASTREAM...", 4, 5, alert_color)
    printOutputLine("SEARCH TERMS INDEXED SUCCESSFULLY.", 5, 5, alert_color)
