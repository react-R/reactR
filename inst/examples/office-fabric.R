library(htmltools)
library(reactR)

fabric <- htmlDependency(
  name = "office-fabric-ui-react",
  version = "7.121.12",
  src = c(href="https://unpkg.com/office-ui-fabric-react@7.121.12/dist/"),
  script = "office-ui-fabric-react.min.js",
  stylesheet = "css/fabric.min.css"
)

browsable(
  tagList(
    html_dependency_react(),
    fabric
  )
)

browsable(
  tagList(
    html_dependency_react(),
    fabric,
    tags$div(id = "app-button"),
    tags$script(HTML(babel_transform(
"
let btn = <div className='ms-BasicButtonsExample'>
  <Fabric.Label>Command button</Fabric.Label>
  <Fabric.CommandButton
    data-automation-id='test'
    icon='AddFriend'
  >
    Create account
  </Fabric.CommandButton>
</div>

ReactDOM.render(btn, document.querySelector('#app-button'));
"
    )))
  )
)


browsable(
  tagList(
    html_dependency_react(),
    fabric,
    tags$div(id="pivot-example"),
    tags$script(HTML(babel_transform(
"
class PivotBasicExample extends React.Component {
  render() {
    return (
      <div>
        <Fabric.Pivot>
          <Fabric.PivotItem linkText='My Files'>
            <Fabric.Label>Pivot #1</Fabric.Label>
          </Fabric.PivotItem>
          <Fabric.PivotItem linkText='Recent'>
            <Fabric.Label>Pivot #2</Fabric.Label>
          </Fabric.PivotItem>
          <Fabric.PivotItem linkText='Shared with me'>
            <Fabric.Label>Pivot #3</Fabric.Label>
          </Fabric.PivotItem>
        </Fabric.Pivot>
      </div>
    );
  }
}
ReactDOM.render(<PivotBasicExample />, document.querySelector('#pivot-example'));
"
    )))
  )
)
