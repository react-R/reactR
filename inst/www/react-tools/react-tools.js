window.reactR = (function () {
    /**
     * Recursively transforms tag, a JSON representation of an instance of a
     * React component and its children, into a React element suitable for
     * passing to ReactDOM.render.
     * @param {Object} components
     * @param {Object} tag
     */
    function hydrate(components, tag) {
        if (typeof tag === 'string') return tag;
        if (tag.name[0] === tag.name[0].toUpperCase()
            && !components.hasOwnProperty(tag.name)) {
            throw new Error("Unknown component: " + tag.name);
        }
        var elem = components.hasOwnProperty(tag.name) ? components[tag.name] : tag.name,
            args = [elem, tag.attribs];
        for (var i = 0; i < tag.children.length; i++) {
            args.push(hydrate(components, tag.children[i]));
        }
        return React.createElement.apply(React, args);
    }

    var defaultOptions = {
        // The name of the property on the root tag to use for the width, if
        // it's updated.
        widthProperty: "width",
        // The name of the property on the root tag to use for the height, if
        // it's updated.
        heightProperty: "height",
        // Whether or not to append the string 'px' to the width and height
        // properties when they change.
        appendPx: false,
        // Whether or not to dynamically update the width and height properties
        // of the last known tag when the computed width and height change in
        // the browser.
        renderOnResize: false
    };

    function mergeOptions(options) {
        var merged = {};
        for (var k in defaultOptions) {
            merged[k] = defaultOptions[k];
        }
        for (var k in options) {
            if (!defaultOptions.hasOwnProperty(k)) {
                throw new Error("Unrecognized option: " + k);
            }
            merged[k] = options[k];
        }
        return merged;
    }

    function formatDimension(dim, options) {
        if (options.appendPx) {
            return dim + 'px';
        } else {
            return dim;
        }
    }

    function isTag(value) {
        return (typeof value === 'object')
            && value.hasOwnProperty('name')
            && value.hasOwnProperty('attribs')
            && value.hasOwnProperty('children');
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
                var lastValue,
                    renderValue = (function (value) {
                        if (actualOptions.renderOnResize) {
                            // value.tag might be a primitive string, in which
                            // case there is no attribs property.
                            if (typeof value.tag === 'object') {
                                value.tag.attribs[actualOptions["widthProperty"]] = formatDimension(width);
                                value.tag.attribs[actualOptions["heightProperty"]] = formatDimension(height);
                            }
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
        hydrate: hydrate,
        __internal: {
            defaultOptions: defaultOptions,
            mergeOptions: mergeOptions,
            formatDimension: formatDimension,
            isTag: isTag
        }
    };
})()