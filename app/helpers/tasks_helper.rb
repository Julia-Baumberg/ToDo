module TasksHelper

  def toggle_completion_button(task, options = {})
    label = task.is_completed ? "Mark Incomplete" : "Mark Completed"
    css_class = task.is_completed ? "btn btn-not-completed" : "btn btn-success"

    css_class = "#{css_class} #{options[:class]}".strip

    button_to label,
              mark_completed_task_path(task),
              method: :patch,
              class: css_class,
              form_class: options[:form_class] || "d-inline"
  end

end
