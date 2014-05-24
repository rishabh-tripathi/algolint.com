module ApplicationHelper

  # This function will generate ajax form 
  def form_remote_tag(options)    
    data_type = "data-type='html'"
    data_type = "" if(!options[:html][:res_type].blank?)
    res_format = "$('##{options[:update]}').html(data);"   
    res_format = "" if(data_type.blank?)    
    str = "<form action=\"#{options[:url]}\" method=\"#{options[:method]}\" data-remote=true id=\"#{options[:html][:id]}\" #{data_type}>"
    str += "<script type=\"text/javascript\">
              $(document).ready(function(){
                $('##{options[:html][:id]}').bind(\"ajax:beforeSend\", function(evt, xhr, settings){
                  xhr.setRequestHeader('X-CSRF-Token', $('meta[name=\"csrf-token\"]').attr('content'));
                  #{options[:conditions] if(!options[:conditions].blank?)}
                  #{options[:loading] if(!options[:loading].blank?)}
                }).bind(\"ajax:success\", function(evt, data, status, xhr){
                  #{res_format}
                }).bind(\"ajax:complete\", function(evt, xhr, status){
                  #{options[:complete]}
                }).bind(\"ajax:error\", function(evt, xhr, status, error){
                  #{options[:failure]}
                });
              });
            </script>"
    return str.html_safe    
  end
  
  # End of ajax form
  def end_form
    return "</form>".html_safe
  end

end
