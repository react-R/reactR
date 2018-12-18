window.reactR = (function () {
    /**
     * Recursively transforms tag, a JSON representation of an instance of a
     * React component and its children, into a React element suitable for
     * passing to ReactDOM.render.
     * @param {Object} components
     * @param {Object} tag
     */
    function hydrate(components, tag) {
        if (tag.name[0] !== tag.name[0].toUpperCase()) {
            throw new Error("Component does not begin with a capital letter: " + tag.name);
        }
        if (!components.hasOwnProperty(tag.name)) {
            throw new Error("Unknown component: " + tag.name);
        }
        var args = [components[tag.name], tag.attribs];
        for (var i = 0; i < tag.children.length; i++) {
            args.push(hydrate(components, tag.children[i]));
        }
        // Look into a way to clone an element and apply new props
        return React.createElement.apply(null, args);
    }

    // TODO default set of options
    // TODO Look at ReactDOM.findDOMNode()

    var defaultOptions = {
        widthProperty: "width",
        heightProperty: "height",
        appendPx: false,
        renderOnResize: false
    }

    /**
     * If options contains recognized option names, returns a new object with
     * defaultOptions and user options merged. User options take precedence.
     * @param {Object} options An object of user-supplied keys and values
     * @returns {Object} The merged options
     */
    function mergeOptions(options) {
        for (var k in options) {
            if (!defaultOptions.hasOwnProperty(k)) {
                throw new Error("Unrecognized option: " + k);
            }
        }
        return jQuery.extend({}, defaultOptions, options);
    }

    /**
     * Formats a dimension value based on options
     * @param {Object} dimension The dimension value to format
     * @param {Object} options The options, which should contain an appendPx key
     */
    function formatDimension(dimension, options) {
        if (dimension === null) {
            return;
        } else if (options.appendPx) {
            return dimension.toString() + "px";
        } else {
            return dimension;
        }
    }

    /**
     * If options.renderOnResize is true, returns a shallow clone of element with two additional props: width and height.
     * @param {Object} element
     * @param {number} width
     * @param {number} height
     * @param {Object} options
     */
    function withDimensions(element, width, height, options) {
        if (options.renderOnResize) {
            var newProps = {};
            newProps[options["widthProperty"]] = formatDimension(width, options);
            newProps[options["heightProperty"]] = formatDimension(height, options);
            return React.cloneElement(element, newProps);
        } else {
            return element;
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
                var lastRenderedElement = null;
                return {
                    renderValue: (function (value) {
                        lastRenderedElement = withDimensions(
                            hydrate(components, value.tag),
                            width,
                            height,
                            actualOptions
                        );
                        ReactDOM.render(lastRenderedElement, el);
                    }),
                    resize: function (newWidth, newHeight) {
                        if (actualOptions.renderOnResize) {
                            lastRenderedElement = withDimensions(
                                lastRenderedElement,
                                newWidth,
                                newHeight,
                                actualOptions
                            );
                            ReactDOM.render(lastRenderedElement, el);
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