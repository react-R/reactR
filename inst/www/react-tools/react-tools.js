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
        return React.createElement.apply(null, args);
    }

    /**
     * Creates an HTMLWidget that is updated by rendering a React component.
     * React component constructors are made available by specifying them by
     * name in the components object.
     * @param {string} name 
     * @param {string} type 
     * @param {Object} components 
     */
    function exposeComponents(name, type, components) {
        HTMLWidgets.widget({
            name: name,
            type: type,
            factory: function (el, width, height) {
                return {
                    renderValue: (function (value) {
                        ReactDOM.render(hydrate(components, value.tag), el);
                    }),
                    resize: function (width, height) {
                        // TODO: What should happen here?
                    }
                };
            }
        })
    }

    return {
        exposeComponents: exposeComponents
    };
})()