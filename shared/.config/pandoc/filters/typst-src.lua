-- Convert `#+begin_src typst` blocks into raw typst so `pandoc --pdf-engine=typst`
-- compiles them as real content instead of printing verbatim code listings.
function CodeBlock(el)
  if el.classes[1] == 'typst' then
    return pandoc.RawBlock('typst', el.text)
  end
end
