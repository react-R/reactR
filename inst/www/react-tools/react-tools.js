/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./srcjs/react-tools.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./srcjs/react-tools.js":
/*!******************************!*\
  !*** ./srcjs/react-tools.js ***!
  \******************************/
/*! no static exports found */
/***/ (function(module, exports) {

function _typeof(obj) { if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

window.reactR = function () {
  /**
   * Recursively transforms tag, a JSON representation of an instance of a
   * React component and its children, into a React element suitable for
   * passing to ReactDOM.render.
   * @param {Object} components
   * @param {Object} tag
   */
  function hydrate(components, tag) {
    if (typeof tag === 'string') return tag;

    if (tag.name[0] === tag.name[0].toUpperCase() && !components.hasOwnProperty(tag.name)) {
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
    return _typeof(value) === 'object' && value.hasOwnProperty('name') && value.hasOwnProperty('attribs') && value.hasOwnProperty('children');
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
      factory: function factory(el, width, height) {
        var lastValue,
            instance = {},
            renderValue = function renderValue(value) {
          if (actualOptions.renderOnResize) {
            // value.tag might be a primitive string, in which
            // case there is no attribs property.
            if (_typeof(value.tag) === 'object') {
              value.tag.attribs[actualOptions["widthProperty"]] = formatDimension(width);
              value.tag.attribs[actualOptions["heightProperty"]] = formatDimension(height);
            }

            lastValue = value;
          }

          this.instance.component = ReactDOM.render(hydrate(components, value.tag), el);
        };

        return {
          instance: instance,
          renderValue: renderValue,
          resize: function resize(newWidth, newHeight) {
            if (actualOptions.renderOnResize) {
              width = newWidth;
              height = newHeight;
              renderValue(lastValue);
            }
          }
        };
      }
    });
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
}();

/***/ })

/******/ });
//# sourceMappingURL=react-tools.js.map