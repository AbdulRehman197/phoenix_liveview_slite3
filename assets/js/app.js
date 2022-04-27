// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css";

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let Hooks = {};
Hooks.update_customer = {
  mounted() {
    document.getElementById("new-entry").focus();
    this.el.addEventListener("keyup", (evt) => {
      if (evt.keyCode === 13 && evt.target.value) {
        // 13 = Enter key
        let [field, id] = evt.target.id.split("-");
        this.pushEvent(
          "update",
          {
            field,
            id,
            value: evt.target.value,
          },
          () => {
            if (this.el.parentElement.nextElementSibling) {
              this.el.parentElement.nextElementSibling.children[0].focus();
            } else {
              this.el.parentElement.parentElement.nextElementSibling?.children[1]?.children[0].focus();
            }
          }
        );
      } else if (evt.keyCode === 37) {
        // 37 = left arrow key
        if (this.el.parentElement.previousElementSibling.children[0].disabled) {
          this.el.parentElement.parentElement.previousElementSibling?.children[
            this.el.parentElement.parentElement.previousElementSibling?.children
              .length - 1
          ].children[0].focus();
        } else if (this.el.parentElement.previousElementSibling) {
          this.el.parentElement.previousElementSibling.children[0].focus();
        }
      } else if (evt.keyCode === 38) {
        // 38 = up arrow key
        let arr = this.el.parentElement.parentElement.previousElementSibling
          ? [
              ...this.el.parentElement.parentElement.previousElementSibling
                .children,
            ]
          : [];
        arr.forEach((element, index, prevRow) => {
          if (
            element.children[0].id &&
            this.el.id.split("-")[0] === element.children[0].id.split("-")[0]
          ) {
            prevRow[index].children[0]?.focus();
          }
        });
      } else if (evt.keyCode === 39) {
        // 39 = right arrow key
        if (this.el.parentElement.nextElementSibling) {
          this.el.parentElement.nextElementSibling.children[0].focus();
        } else if (
          this.el.parentElement.parentElement.nextElementSibling?.children[0]
            .children[0].disabled
        ) {
          this.el.parentElement.parentElement.nextElementSibling?.children[1].children[0].focus();
        }
      } else if (evt.keyCode === 40) {
        // 40 = down arrow key
        let arr = this.el.parentElement.parentElement.nextElementSibling
          ? [
              ...this.el.parentElement.parentElement.nextElementSibling
                .children,
            ]
          : [];
        arr.forEach((element, index, nextRow) => {
          if (
            element.children[0].id &&
            this.el.id.split("-")[0] === element.children[0].id.split("-")[0]
          ) {
            nextRow[index].children[0]?.focus();
          }
        });
      }
    });
  },
};

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (info) => topbar.show());
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();
window.liveSocket = liveSocket;

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
