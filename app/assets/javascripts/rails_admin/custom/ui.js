//= require turbolinks
//= require_tree
$(document).on("ready", function() {
  setTimeout(function() {
    $(".alert-info").fadeOut("normal");
  }, 3000);

  if ($("#question_question_type").val() == "text") {
    $(".remove-button").trigger("click");
    $(".add-button").trigger("click");
    $(".add-button").hide();
    $(".check-box-remove").hide();
    $(".answer-title").html("Answer");
  }
});

$(document).on("page:load page:update", check_box_state);
$(document).on("page:load page:update", check_box_state_edit);
$(document).on("page:update", answer_title);
$(document).on("page:update", select_question_type);
$(document).on("page:update", check_question_type);

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".form-group").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).parent().before(content.replace(regexp, new_id));
  answer_title();
}

function check_question_type() {
  if ($("span.question_type_text").length) {
    if ($("span.question_type_text").text() === "Text"){
      $(".add-button").hide();
      $(".check-box-remove").hide();
      $(".answer-title").html("Answer");
    }else{
      $(".add-button").show();
      $(".check-box-remove").show();
      $(".answer-title").html("Option");
    }
  }
}

function answer_title() {
  if ($("#question_question_type").val() === "text"){
    $(".answer-title").html("Answer");
  }else{
    $(".answer-title").html("Option");
  }
}

function check_box_state() {
  $(".check-box").on("change",function(){
    if ($("#question_question_type").val() === "single_choice"){
      $(".check-box").not(this).prop("checked", false);
    }
  });
}

function select_question_type() {
  $("#question_question_type").on("change",function() {
    if (this.value === "text"){
      $(".remove-button").trigger("click");
      $(".add-button").trigger("click");
      $(".add-button").hide();
      $(".check-box-remove").hide();
      $(".answer-title").html("Answer");
    }else{
      $(".check-box").prop("checked", false);
      $(".add-button").show();
      $(".check-box-remove").show();
      $(".answer-title").html("Option");
      if (this.value === "single_choice") {
        $(".check-box:first").prop("checked", true);
      }
    }
  });
}

function check_box_state_edit() {
  $(".check-box").on("change",function(){
    if ($("span.question_type_text").text() === "Single_choice"){
      $(".check-box").not(this).prop("checked", false);
    }
  });
}
