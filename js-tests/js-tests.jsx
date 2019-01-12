import React from 'react';
import ReactDOM from 'react';
import { renderToString, renderToStaticMarkup } from 'react-dom/server';
import parseXml from '@rgrove/parse-xml';
import ReactHtmlParser from 'react-html-parser';

/**
 * Needed by react-tools.js
 * In normal operation, these are added to the page as htmlDependencies.
 */
window.React = React;
window.ReactDOM = ReactDOM;

class Shout extends React.Component {
    render() {
        return <span>{this.props.message.toUpperCase()}</span>;
    }
}

const FunctionalShout = ({ message }) => {
    return <span>{message.toUpperCase()}</span>;
}

class TodoList extends React.Component {
    render() {
        return <ol>
            {this.props.children.map((child, i) => {
                return <li key={i}>{child}</li>;
            })}
        </ol>
    }
}

// Converts a parse-xml style tree to an htmltools::tag style tree of JSON.
function objectToTag(obj) {
    return {
        name: obj.name,
        attribs: obj.attributes,
        children: obj.children.map(child => {
            if (child.type === 'text') {
                return child.text;
            } else {
                return objectToTag(child);
            }
        })
    }
}

// Converts a string of markup to an htmltools::tag style tree of JSON.
function stringToTag(str) {
    return objectToTag(parseXml(str).children[0]);
}

// Compares two parse-xml style trees for "deep" equality
function xmlEqual(x1, x2) {
    if (x1.type === 'text'
        && x2.type === 'text'
        && x1.text === x2.text)
        return true;
    return x1.name === x2.name
        // Test attributes for equality
        && Object.keys(x1).length === Object.keys(x2).length
        && Object.keys(x1).every(k => x1[k] === x2[k])
        // Test children for equality
        && x1.children.length === x2.children.length
        && x1.children.every((child, i) => xmlEqual(child, x2.children[i]))
}

describe('window.reactR', () => {
    describe('#hydrate() with HTML', () => {
        it('hydrates an HTML5 component with a text child', () => {
            const markup = '<h1>Hello</h1>';
            assert.equal(
                renderToString(ReactHtmlParser(markup)),
                renderToString(reactR.hydrate({}, stringToTag(markup)))
            )
        })
        it('hydrates nested HTML5 components', () => {
            const markup = '<div><h1>Hello</h1><p>Oh, hello.</p></div>'
            assert.equal(
                renderToString(ReactHtmlParser(markup)),
                renderToString(reactR.hydrate({}, stringToTag(markup)))
            )
        })
    });
    describe('#hydrate() with Components', () => {
        it('should throw an exception with an unknown component', () => {
            assert.throws(() => {
                reactR.hydrate({ Shout: Shout }, stringToTag('<Bar/>'))
            }, Error, /Unknown component/);
        });
    })
});
