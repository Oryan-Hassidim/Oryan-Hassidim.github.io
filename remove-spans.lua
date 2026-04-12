-- מסנן Pandoc למחיקת Spans
function Span(el)
  -- אם יש ל-span הגדרת כיווניות (rtl או ltr), נשמור עליו (קריטי לעברית/אנגלית)
  -- if el.attributes['dir'] then
  --   return el
  -- end
  
  -- אם הגדרת לוורד מחלקות (classes) שאתה כן רוצה לשמור, אפשר לבדוק גם אותן:
  -- if el.classes:includes('my-important-class') then return el end

  -- אחרת, נחזיר רק את התוכן הפנימי (הטקסט עצמו) בלי תגית ה-<span> העוטפת
  return el.content
end