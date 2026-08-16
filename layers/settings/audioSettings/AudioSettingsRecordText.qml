import QtQuick
import QtQuick.Effects
import "../../.."

Canvas {
    id: root
    required property string trackTitle
    required property string trackArtist
    required property string trackAlbum
    // Base angle for curved text, which is used to determine how far apart the letters are placed.
    // Value determined by experimentation.
    property real curvedTextBaseAngle: Config.audioSettings.recordTextBaseAngle
    // Base radius determined via experimentation; this will depend on how big the central
    // circle of the underlying SVG icon is. But since our canvas' width should be keyed off of
    // that, we can just make it some fraction of our own width.
    property real curvedTextBaseRadius: width * Config.audioSettings.recordTextBaseRadiusFactor
    // The text can exceed this arc angle based on how the words wrap, so the config setting is just a target
    property real titleMaxWidth: 2 * Math.PI * curvedTextBaseRadius * Config.audioSettings.recordTextTitleTargetArcFactor
    // Similar for the artist max width.
    property real artistMaxWidth: 2 * Math.PI * curvedTextBaseRadius * Config.audioSettings.recordTextArtistTargetArcFactor
    property real fontSize: Math.floor(width * Config.audioSettings.recordTextFontSizeFactor)

    onPaint: {
        var ctx = getContext("2d");
        // Need to remake whole thing if our track details change (sure technically could redraw only
        // the section that changed but is that really necessary?)
        ctx.clearRect(0, 0, root.width, root.height);

        const fontSize = root.fontSize;
        ctx.font = `${fontSize}px '${Config.fontTypewriter.font.family}'`;
        ctx.textAlign = "center";
        ctx.fillStyle = Config.audioSettings.recordTextColor;

        var centerX = width / 2;
        var centerY = height / 2;
        const titleLines = getLines(ctx, root.trackTitle, titleMaxWidth);
        drawTextAlongArcWrapped(ctx, root.trackTitle, centerX, centerY, curvedTextBaseRadius, curvedTextBaseAngle, fontSize, titleMaxWidth);
        // We determine max width of this "center" text based on how many lines we needed to write the
        // track title, to avoid having them clip into each other.
        const centralTextMaxWidth = curvedTextBaseRadius * 2 - titleLines.length * fontSize;
        drawTextWrapped(ctx, root.trackAlbum, centerX, centerY, centralTextMaxWidth, fontSize);
        drawTextAlongArcWrapped(ctx, root.trackArtist, centerX, centerY, curvedTextBaseRadius, curvedTextBaseAngle, fontSize, artistMaxWidth, false);
    }
    // https://stackoverflow.com/questions/2936112/text-wrap-in-a-canvas-element
    // Splits text into lines based on what the max width of each line should be
    function getLines(ctx, text, maxWidth) {
        var words = text.split(" ");
        var lines = [];
        var currentLine = words[0];

        for (var i = 1; i < words.length; i++) {
            var word = words[i];
            var width = ctx.measureText(currentLine + " " + word).width;
            if (width < maxWidth) {
                currentLine += " " + word;
            } else {
                lines.push(currentLine);
                currentLine = word;
            }
        }
        lines.push(currentLine);
        return lines;
    }
    // Draw text along a circular arc centered at (centerX, centerY) with the given radius
    // across a total angle. By default, will draw with the concave side on the bottom of
    // the text; if up is given as false, the concave side will be the top of the text.
    // Restores the context upon completion.
    // This is adapted from https://stackoverflow.com/questions/50010671/how-i-can-create-a-curved-text-in-qml-canvas-element
    function drawTextAlongArc(context, str, centerX, centerY, radius, angle, up = true) {
        context.save();
        context.translate(centerX, centerY);
        const fac = up ? -1 : 1;
        context.rotate(-1 * angle / 2);
        context.rotate(-1 * (angle / str.length) / 2);
        for (var n = 0; n < str.length; n++) {
            context.rotate(angle / str.length);
            context.save();
            context.translate(0, fac * radius);
            var char1 = str[up ? n : str.length - n - 1];
            context.fillText(char1, 0, 0);
            context.restore();
        }
        context.restore();
    }
    // Draw text normally centered at (centerX, centerY)
    // Restores the context upon completion
    function drawText(context, str, centerX, centerY) {
        context.save();
        context.translate(centerX, centerY);
        context.fillText(str, 0, 0);
        context.restore();
    }
    // Draw text normally, centered at (centerX, centerY), but wrap it into different lines
    // based on the max width desired for each line. fontSize is used to determine how to place
    // subsequent lines beneath the first one.
    // Restores the context upon completion.
    function drawTextWrapped(context, str, centerX, centerY, maxWidth, fontSize) {
        context.save();
        const lines = getLines(context, str, maxWidth);
        context.translate(0, -fontSize * lines.length * 0.5);
        for (let i = 0; i < lines.length; i++) {
            const line = lines[i];
            context.translate(0, fontSize);
            drawText(context, line, centerX, centerY);
        }
        context.translate(0, fontSize);
        context.restore();
    }
    // Draw text along a circular arc centered at (centerX, centerY) with the given radius
    // across a total angle. By default, will draw with the concave side on the bottom of
    // the text; if up is given as false, the concave side will be the top of the text. The text
    // will be wrapped into concentric arcs of decreasing radius if it is too long to fit within
    // a single arc. fontSize is used to determine how to place subsequent arcs beneath the first one.
    // Restores the context upon completion.
    function drawTextAlongArcWrapped(context, str, centerX, centerY, radius, baseAngle, fontSize, maxWidth, up = true) {
        const lines = getLines(context, str, maxWidth);
        context.save();
        for (let i = 0; i < lines.length; i++) {
            // If text is concave-up we need to write the first line as the smallest circle
            const line = lines[up ? i : lines.length - i - 1];
            const titleAngle = baseAngle * line.length; // radians
            // Each line gets a progressively smaller radius; fortunately this is neatly parameterized
            // by font size
            const lineRadius = radius - i * fontSize;
            drawTextAlongArc(context, line, centerX, centerY, lineRadius, titleAngle, up);
        }
        context.restore();
    }
}
