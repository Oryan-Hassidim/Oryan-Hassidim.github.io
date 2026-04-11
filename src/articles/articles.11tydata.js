import fs from 'node:fs';
import path from 'node:path';

export default {
    layout: "article.njk",
    tags: ["article"], // מקבץ את כולם תחת collection אחד
    eleventyComputed: {
        // פונקציה שרצה על כל מאמר ומחזירה רשימה של הקבצים המצורפים אליו
        downloads: (data) => {
            // מוצא את התיקייה הספציפית שבה נמצא המאמר הנוכחי
            const dir = path.dirname(data.page.inputPath);
            try {
                const files = fs.readdirSync(dir);
                // מסנן רק את קבצי ה-PDF וה-DOCX
                return files.filter(f => f.endsWith('.pdf') || f.endsWith('.docx'));
            } catch (e) {
                return [];
            }
        }
    }
};