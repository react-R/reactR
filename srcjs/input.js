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
 * reactInput.
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
  receiveMessage: defaultReceiveMessage
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
 */
export function reactInput(selector,
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
    setValue(el, value) {
      this.setInputValue(el, value);
      this.getCallback(el)();
      this.render(el);
    }
    subscribe(el, callback) {
      $(el).data('callback', callback);
      this.render(el);
    }
    unsubscribe(el, callback) {
      // TODO
    }
    receiveMessage(el, data) {
      options.receiveMessage.call(this, el, data);
    }

    /* 
     * Methods not present in Shiny.InputBinding but accessible to users
     * through `this` in receiveMessage
     * */

    getInputValue(el) {
      return JSON.parse($(el).next().text());
    }
    setInputValue(el, value) {
      $(el).next().text(JSON.stringify(value));
    }
    getInputConfiguration(el) {
      return JSON.parse($(el).next().next().text());
    }
    setInputConfiguration(el, value) {
      $(el).next().next().text(JSON.stringify(value));
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

