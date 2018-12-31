window.reactR = (function () {
    /**
     * Inject an event handler prop to pass through to Shiny
     */
    function addShiny(tag, event, el) {
        // bail if we aren't in a Shiny context
        if (!HTMLWidgets.shinyMode) return tag;
        var id = tag.name;
        // if tag has an attribute id then use that instead
        if(tag.attribs.hasOwnProperty("id")) {
            id = tag.attribs.id;
        }
        tag.attribs[event] = function(value) {
            Shiny.onInputChange(this.id + "_" + id + "_" + event, value);
        }.bind(el);
        return tag;
    }

    /**
     * Recursively transforms tag, a JSON representation of an instance of a
     * React component and its children, into a React element suitable for
     * passing to ReactDOM.render.
     * @param {Object} components
     * @param {Object} tag
     */
    function hydrate(components, tag, el) {
        if (tag.type === "js") {
            return window.eval(tag.js);
        }
        if (tag.name[0] === tag.name[0].toUpperCase()
            && !components.hasOwnProperty(tag.name)) {
            throw new Error("Unknown component: " + tag.name);
        }
        // check to see if there is a shiny prop
        //  and if so then add the event handler
        if(tag.attribs.hasOwnProperty("shinyEvent")) {
            tag = addShiny(tag, tag.attribs.shinyEvent, el);
        }
        for (var k in tag.attribs) {
            var v = tag.attribs[k];
            if ((typeof v === 'object')
                && v.tag !== undefined
                && v.tag.type === 'js') {
                tag.attribs[k] = window.eval(v.tag.js);
            }
        }
        var args = [components[tag.name], tag.attribs];
        for (var i = 0; i < tag.children.length; i++) {
            args.push(hydrate(components, tag.children[i], el));
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
                    ReactDOM.render(hydrate(components, value.tag, el), el);
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
