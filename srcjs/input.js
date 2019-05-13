import React from 'react';
import ReactDOM from 'react-dom';
import Shiny from 'shiny';
import $ from 'jquery';

/*
 * This default receiveMessage implementation expects data to contain whole
 * configuration and value properties. If either is present, it will be set and
 * the component will be re-rendered. Because receiveMessage is typically used
 * by input authors to perform incremental updates, this default implementation
 * can be overriden by the user with the receiveMessage arguments to
 * reactShinyInput.
 */
function defaultReceiveMessage(el, { configuration, value }) {
  let dirty = false;
  if (configuration !== undefined) {
    this.setInputConfiguration(el, configuration);
    dirty = true;
  }
  if (value !== undefined) {
    this.setInputValue(el, value);
    dirty = true;
  }
  if (dirty) {
    this.getCallback(el)();
    this.render(el);
  }
}

const defaultOptions = {
  receiveMessage: defaultReceiveMessage,
  type: false,
  ratePolicy: null
};

/**
 * Installs a new Shiny input binding based on a React component.
 *
 * @param {string} selector - jQuery selector that should identify the set of
 * container elements within the scope argument of Shiny.InputBinding.find.
 * @param {string} name - A name such as 'acme.FooInput' that should uniquely
 * identify the component.
 * @param {Object} component - React Component, either class or function.
 * @param {Object} options - Additional configuration options. Supported
 * options are:
 * - receiveMessage: Implementation of Shiny.InputBinding to use in place of
 *   the default. Typically overridden as an optimization to perform
 *   incremental value updates.
 * - type: `false`, a string, or a function.
 *     - `false` (the default): denotes that the value produced by this input
 *       should not be intercepted by any handlers registered in R on the
 *       server using shiny::registerInputHandler().
 *     - string: denotes the input's *type* and should correspond to the
 *       type parameter of shiny::registerInputHandler().
 *     - function: A function called with `this` bound to the InputBinding
 *       instance and passed a single argument, the input's containing DOM
 *       element. The function should return either `false` or a string
 *       corresponding to the type parameter of shiny::registerInputHandler().
 * - ratePolicy: A rate policy object as defined in the documentation for
 *     getRatePolicy(): https://shiny.rstudio.com/articles/building-inputs.html
 *     A rate policy object has two members:
 *     - `policy`: Valid values are the strings "direct", "debounce", and
 *       "throttle". "direct" means that all events are sent immediately.
 *     - `delay`: Number indicating the number of milliseconds that should be
 *       used when debouncing or throttling. Has no effect if the policy is
 *       direct.
 *     The specified rate policy is only applied when `true` is passed as the
 *     second argument to the `setValue` function passed as a prop to the
 *     input component.
 *
 */
export function reactShinyInput(selector,
                           name,
                           component,
                           options) {
  options = Object.assign({}, defaultOptions, options);
  Shiny.inputBindings.register(new class extends Shiny.InputBinding {

    /*
     * Methods override those in Shiny.InputBinding
     */

    find(scope) {
      return $(scope).find(selector);
    }
    getValue(el) {
      return this.getInputValue(el);
    }
    setValue(el, value, rateLimited = false) {
      /*
       * We have to check whether $(el).data('callback') is undefined here
       * in case shiny::renderUI() is involved. If an input is contained in a
       * shiny::uiOutput(), the following strange thing happens occasionally:
       *
       *   1. setValue() is bound to an el in this.render(), below
       *   2. An event that will call setValue() is enqueued
       *   3. While the event is still enqueued, el is unbound and removed
       *      from the DOM by the JS code associated with shiny::uiOutput()
       *      - That code uses jQuery .html() in output_binding_html.js
       *      - .html() removes el from the DOM and clears ist data and events
       *   4. By the time the setValue() bound to the original el is invoked,
       *      el has been unbound and its data cleared.
       *
       *  Since the original input is gone along with its callback, it
       *  seems to make the most sense to do nothing.
       */
      if ($(el).data('callback') !== undefined) {
        this.setInputValue(el, value);
        this.getCallback(el)(rateLimited);
        this.render(el);
      }
    }
    initialize(el) {
      $(el).data('value', JSON.parse($(el).next().text()));
      $(el).data('configuration', JSON.parse($(el).next().next().text()));
    }
    subscribe(el, callback) {
      $(el).data('callback', callback);
      this.render(el);
    }
    unsubscribe(el) {
      ReactDOM.render(null, el);
    }
    receiveMessage(el, data) {
      options.receiveMessage.call(this, el, data);
    }
    getType(el) {
      if (typeof options.type === 'function') {
        return options.type.call(this, el);
      } else if (options.type === false || typeof options.type === 'string') {
        return options.type;
      } else {
        throw new Error('options.type must be false, a string, or a function');
      }
    }
    getRatePolicy() {
      return options.ratePolicy;
    }

    /*
     * Methods not present in Shiny.InputBinding but accessible to users
     * through `this` in receiveMessage
     */

    getInputValue(el) {
      return $(el).data('value');
    }
    setInputValue(el, value) {
      $(el).data('value', value);
    }
    getInputConfiguration(el) {
      return $(el).data('configuration');
    }
    setInputConfiguration(el, configuration) {
      $(el).data('configuration', configuration);
    }
    getCallback(el) {
      return $(el).data('callback');
    }
    render(el) {
      const element = React.createElement(component, {
        configuration: this.getInputConfiguration(el),
        value: this.getValue(el),
        setValue: this.setValue.bind(this, el)
      });
      ReactDOM.render(element, el);
    }
  }, name);
}

