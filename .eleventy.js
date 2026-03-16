export default function (eleventyConfig) {
    eleventyConfig.addPassthroughCopy("**/*.css");
    eleventyConfig.addPassthroughCopy("**/*.js");

    eleventyConfig.addWatchTarget("**/*.css");
    eleventyConfig.addWatchTarget("**/*.js");

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
