// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery; // Bootstrap requires a global "$" object.
import "bootstrap";


$(function () {


  $('.finish-button').click((ev) => {
    let user_id = $(ev.target).data('user-id');
    let tbid = $(ev.target).data('id')
    let path = $(ev.target).data('path')

    let text = JSON.stringify({
      id: tbid,
      time_block: {
        user_id,
        id: tbid,
        finished: true
      }
    });

    console.log(text)

    $.ajax(path, {
      method: "put",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: text,
      success: (resp) => {
        let idToUpdate = `#tb-${resp.data.id}`
        console.log(idToUpdate)
        $(idToUpdate).text(`\n${resp.data.end_time}\n`)
       console.log(resp.data.end_time)
      },
    });
  });

  $('#start-button').click((ev) => {
    let user_id = $(ev.target).data('user-id');
    let task_id = $(ev.target).data('task-id')

    let text = JSON.stringify({
      time_block: {
        user_id,
        task_id,
      }
    });

    console.log(text)

    $.ajax(time_block_path, {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: text,
      success: (resp) => {
       console.log(resp)
      },
    });
  });
});
