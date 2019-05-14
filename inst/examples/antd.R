library(htmltools)
library(reactR)
library(pipeR)

antd <- htmlDependency(
  name = "antd",
  version = "2.13.10",
  src = c(href="https://unpkg.com/antd@2.13.10/dist"),
  script = "antd.min.js",
  stylesheet = "antd.min.css"
)


### menu ####
tl <- tagList(
  tags$div(id="app",style="width:25%;"),
  tags$script(HTML(babel_transform('
  var menu = <antd.Menu mode="horizontal">
     <antd.Menu.Item key="mail">
      <antd.Icon type="mail" />Navigation One
     </antd.Menu.Item>
      <antd.Menu.Item key="app" disabled>
        <antd.Icon type="appstore" />Navigation Two
     </antd.Menu.Item>
  </antd.Menu>

  ReactDOM.render(menu, document.querySelector("#app"))
  ')))
)

browsable(
  tagList(
    tl,
    html_dependency_react(),
    antd
  )
)


### steps ####
steps <- tag(
  "antd.Steps",
  list(
    current=noquote("{1}"),
    tag("antd.Steps.Step", list(title="Finished", description="This is a description." )),
    tag("antd.Steps.Step", list(title="In Progress",description="This is a description." )),
    tag("antd.Steps.Step", list(title="Waiting", description="This is a description." ))
  )
)

tagList(
  tags$div(id="stepapp"),
  steps %>>%
  {
    sprintf(
"
const steps = %s;
ReactDOM.render(steps, document.querySelector('#stepapp'));
",
      .

    )
  } %>>%
    babel_transform() %>>%
    HTML %>>%
    tags$script()
) %>>%
  attachDependencies(
    list(
      html_dependency_react(),
      antd
    )
  ) %>>%
  browsable()


### steps with button ####
steps_button <- list(
  list(
    title= 'Data',
    content= 'Raw Data'
  ),
  list(
    title= 'Model',
    content= 'Code for Model'
  ),
  list(
    title= 'Plot',
    content= 'Beautiful Plot'
  )
) %>>% jsonlite::toJSON(auto_unbox=TRUE)

content_data <- tags$pre(
  HTML(paste0(
    capture.output(str(iris,max.level=1)),
    collapse="<br/>"
  ))
)

content_model <- tags$pre("lm(Petal.Width~Petal.Length, data=iris)")

content_plot <- HTML(
  svglite::htmlSVG({plot(lm(Petal.Length~Petal.Width,data=iris),which=1)},standalone=FALSE)
)

tagList(
  tags$div(id="stepapp", style="width:30%;"),
  steps_button %>>%
    {
      sprintf(
'
const steps = %s;

steps[0].content = %s;
steps[1].content = %s;
steps[2].content = <img src="%s" />

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      current: 0,
    };
  }
  next() {
    const current = this.state.current + 1;
    this.setState({ current });
  }
  prev() {
    const current = this.state.current - 1;
    this.setState({ current });
  }
  render() {
    const { current } = this.state;
    return (
      <div>
        <antd.Steps current={current} size="small">
          {steps.map(item => <antd.Steps.Step key={item.title} title={item.title} />)}
        </antd.Steps>
      <div className="steps-content" style={{minHeight: "600px", display: "flex", alignItems: "center"}}>
        {steps[this.state.current].content}
      </div>
      <div className="steps-action">
        {
          this.state.current < steps.length - 1
          &&
          <antd.Button type="primary" onClick={() => this.next()}>Next</antd.Button>
        }
        {
          this.state.current === steps.length - 1
          &&
          <antd.Button type="primary" onClick={() => message.success("Processing complete!")}>Done</antd.Button>
        }
        {
          this.state.current > 0
          &&
          <antd.Button style={{ marginLeft: 8 }} type="ghost" onClick={() => this.prev()}>
            Previous
          </antd.Button>
        }
        </div>
      </div>
    );
  }
}

ReactDOM.render(<App />, document.querySelector("#stepapp"));
      ',
      .,
      content_data,
      content_model,
      base64enc::dataURI(rsvg::rsvg_png(charToRaw(content_plot)),mime="image/png")
    )
  } %>>%
    babel_transform() %>>%
    HTML %>>%
    tags$script()
) %>>%
  attachDependencies(
    list(
      html_dependency_react(offline=FALSE),
      antd
    )
  ) %>>%
  browsable()
