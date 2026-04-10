export default function (eleventyConfig) {
    eleventyConfig.addPassthroughCopy("src/**/*.css");
    eleventyConfig.addPassthroughCopy("src/**/*.js");
    eleventyConfig.addPassthroughCopy("src/**/images/**/*.*");

    eleventyConfig.addWatchTarget("src/**/*.css");
    eleventyConfig.addWatchTarget("src/**/*.js");

    return {
        dir: {
            input: "src",
            output: "_site",
            includes: "_includes",
            layouts: "_layouts"
        },
        htmlTemplateEngine: "njk",
        markdownTemplateEngine: "njk",
        templateFormats: ["html", "njk", "md"]
    };
}
