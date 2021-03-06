------------------------------------------------------------------
-- This script will add some convenient links to the official   --
-- KoL wiki. Description popup windows will have the name of    --
-- whatever is being described link to the wiki (while also     --
-- closing the popup window), and monster and adventure names   --
-- will also link to the wiki.                                  --
------------------------------------------------------------------

local function printer_replace(pattern, substituter)
  return function()
    text = text:gsub(pattern, substituter)
  end
end

local function link_substitution_function(extra)
  extra = extra or ""
  return function(pre, name, post)
    return pre .. "<a href=\"http://kol.coldfront.net/thekolwiki/index.php/Special:Search?search=" .. name .. "&go=Go\" target=\"_blank\"" .. extra .. ">" .. name .. "</a>" .. post
  end
end

local link_substitution_close = link_substitution_function(" onclick=\"window.close();\"")
local link_substitution_noclose = link_substitution_function()

-- Description popup windows, these make the name link to the wiki page with the added function of closing the popup if you click them.
add_printer("/desc_item.php", printer_replace("(<br><b>)(.-)(</b></center><p><blockquote>)", link_substitution_close))
add_printer("/desc_familiar.php", printer_replace("(<div id=\"description\">%s*<font face=Arial,Helvetica><center><b>)(.-)(</b><p><img)", link_substitution_close))
add_printer("/desc_skill.php", printer_replace("(width=30 height=30><br><font face=\"Arial,Helvetica\"><b>)(.-)(</b><p><div id=\"smallbits\" class=small>)", link_substitution_close))
add_printer("/desc_guardian.php", printer_replace("(, the level %d+ )(.-)(<p><blockquote><table><tr><td>)", link_substitution_close))
add_printer("/desc_effect.php", printer_replace("( width=30 height=30><p><b>)(.-)(</b><p></center><blockquote>)", link_substitution_close))
add_printer("/desc_outfit.php", printer_replace("(width=50 height=50><br><b>)(.-)(</b><p>Outfit Bonus:)", link_substitution_close))
-- Non combat adventures. Needs to specify that the font color on the link should be white, or it being a link will make it black with a blue background, which is unreadable
-- No clue what the point of the <!--faaaaaaart--> is, since it is not in the same place if you are in a choice adventure with a result info from the previous choice at the top
add_printer("/choice.php", printer_replace("(<centeR><?!?%-?%-?f?a?a?a?a?a?a?a?r?t?%-?%-?>?<table  width=95%%  cellspacing=0 cellpadding=0><tr><td style=\"color: white;\" align=center bgcolor=blue><b>)(.-)(</b></td>)",
            link_substitution_function(" style=\"color: white;\"")))
-- Monster name. Nothing fancy. Pretty sure they intentionally set it up to be as nice as possible to pattern match for the wiki, what with having an extra space if there's no prefix like "a ___" or "the ___"
add_printer("/fight.php", printer_replace("(<span id='monname'>%w*%s*)(.-)(</span>)", link_substitution_noclose))
