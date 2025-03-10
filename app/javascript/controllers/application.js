import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }


const events = [
    "turbo:fetch-request-error",
    "turbo:frame-missing",
    "turbo:frame-load",
    "turbo:frame-render",
    "turbo:before-frame-render",
    "turbo:load",
    "turbo:render",
    "turbo:before-stream-render",
    "turbo:before-render",
    "turbo:before-cache",
    "turbo:submit-end",
    "turbo:before-fetch-response",
    "turbo:before-fetch-request",
    "turbo:submit-start",
    "turbo:visit",
    "turbo:before-visit",
    "turbo:click"
  ]
  
events.forEach(e => {
    addEventListener(e, () => {
        console.log(e);
    });
});

document.addEventListener("turbo:load", () => {
    console.log("Turbo has loaded");
    var templateContent = document.getElementById("templ_content");
    // console.log(templateContent);
    if (templateContent) {
        var editor = CodeMirror.fromTextArea(templateContent, {
            theme: 'elegant',
            mode: "htmlmixed",
            lineWrapping: true,
            lineNumbers: true,
            styleActiveLine: true,
            matchBrackets: true
        });
        editor.save()
        editor.setSize("100%", "500")
    }

});