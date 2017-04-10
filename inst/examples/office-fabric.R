library(htmltools)
library(reactR)
library(pipeR)

fabric <- htmlDependency(
  name = "office-fabric-ui-react",
  version = "0.67.0",
  src = c(href="https://unpkg.com/office-ui-fabric-react/dist"),
  script = "office-ui-fabric-react.js",
  stylesheet = "css/fabric.min.css"
)

tagList() %>>%
  attachDependencies(list(html_dependency_react(),fabric)) %>>%
  browsable()

tagList(
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
  ))),
  html_dependency_react(),
  fabric
) %>>%
  browsable()
