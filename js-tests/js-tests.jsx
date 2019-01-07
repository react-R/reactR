import React from 'react';

describe('window.reactR', () => {
    describe('#hydrate()', () => {
        it('should throw an exception with an unknown component', () => {
            assert.throws(() => {
                reactR.hydrate(
                    {
                        Foo: class Foo extends React.Component {
                            render() {
                                return <h1>Foo!</h1>;
                            }
                        }
                    },
                    {
                        name: "Bar",
                        attribs: {},
                        children: {}
                    }
                )
            }, Error, /Unknown component/);
        });
    });
});
