window.reactR = (function () {
    /**
     * Recursively transforms tag, a JSON representation of an instance of a
     * React component and its children, into a React element suitable for
     * passing to ReactDOM.render.
     * @param {Object} components
     * @param {Object} tag
     */
    function hydrate(components, tag) {
        if (tag.name[0] === tag.name[0].toUpperCase()
            && !components.hasOwnProperty(tag.name)) {
            throw new Error("Unknown component: " + tag.name);
        }
        var args = [components[tag.name], tag.attribs];
        for (var i = 0; i < tag.children.length; i++) {
            args.push(hydrate(components, tag.children[i]));
        }
        return React.createElement.apply(null, args);
    }

    var defaultOptions = {
        widthProperty: "width",
        heightProperty: "height",
        appendPx: false,
        renderOnResize: false
    };

    function mergeOptions(options) {
        for (var k in options) {
            if (!defaultOptions.hasOwnProperty(k)) {
                throw new Error("Unrecognized option: " + k);
            }
        }
        return jQuery.extend({}, defaultOptions, options);
    }

    function formatDimension(dim, options) {
        if (options.appendPx) {
            return dim.toString() + 'px';
        } else {
            return dim;
        }
    }

    /**
     * Creates an HTMLWidget that is updated by rendering a React component.
     * React component constructors are made available by specifying them by
     * name in the components object.
     * @param {string} name
     * @param {string} type
     * @param {Object} components
     * @param {Object} options
     */
    function reactWidget(name, type, components, options) {
        var actualOptions = mergeOptions(options);
        HTMLWidgets.widget({
            name: name,
            type: type,
            factory: function (el, width, height) {
                var lastValue;
                renderValue = (function (value) {
                    if (actualOptions.renderOnResize) {
                        value.tag.attribs[actualOptions["widthProperty"]] = formatDimension(width);
                        value.tag.attribs[actualOptions["heightProperty"]] = formatDimension(height);
                        lastValue = value;
                    }
                    ReactDOM.render(hydrate(components, value.tag), el);
                });
                return {
                    renderValue: renderValue,
                    resize: function (newWidth, newHeight) {
                        if (actualOptions.renderOnResize) {
                            width = newWidth;
                            height = newHeight;
                            renderValue(lastValue);
                        }
                    }
                };
            }
        })
    }

    return {
        reactWidget: reactWidget,
        hydrate: hydrate
    };
})()