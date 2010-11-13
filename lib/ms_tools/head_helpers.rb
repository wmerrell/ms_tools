module MsTools
  module HeadHelpers

    # Adds inline javascript data to the head section of a page.
    #
    # The intent of this function is to simplify your view code when you need
    # javascript specifically for a particular page.
    #
    # Assumes that there is yield call in the <head> section of your layout
    # like this:
    #   <script type="text/javascript">
    #     <%= yield :javascript_data %>
    #   </script>
    #
    #
    # === Usage:
    #   <%- javascript do -%>
    #     alert("Hello world!");
    #   <%- end -%>
    #
    # This function expects a block which will be the javascript you
    # wish to add to the page.
    #
    def javascript(*args, &block)
      if block_given?
        content = capture(&block)
        content_for(:javascript_data) { content }
      end
    end

    # Adds javascript files to the head section of a page.
    #
    # The intent of this function is to simplify your view code when you need
    # special javascript files for a particular page.
    # This function may be called as many times as desired, the javascript files
    # are added in the order they are called.
    #
    # Assumes that there is yield call in the <head> section of your layout
    # like this:
    #   <%= yield :javascript_list %>
    #
    # All of the accumulated javascript files are added, in the order they were
    # called when the page is generated.
    #
    # === Usage:
    #   <%- javascripts 'javascriptname' -%>
    # or
    #   <%- javascripts ['javascriptname1', 'javascriptname2', ...] -%>
    #
    # The function takes either a string or and array of strings, and you
    # may use an string that is valid for the +javascript_include_tag+ function.
    # Be sure to include any paths for the file you wish to add.
    #
    def javascripts(*args)
      items = args.class == Array ? args : args.to_a
      items.each {|item|
        content_for(:javascript_list) { javascript_include_tag item }
      }
    end

    # Adds inline style information to the head section of a page.
    #
    # The intent of this function is to simplify your view code when you need
    # special css style rules for a particular page.
    #
    # Assumes that there is yield call in the <head> section of your layout
    # like this:
    #   <style type="text/css">
    #     <%= yield :stylesheet_data %>
    #   </style>
    #
    #
    # === Usage:
    #   <%- stylesheet do -%>
    #     body {
    #       line-height: 1;
    #       color: black;
    #       background: white;
    #     }
    #   <%- end -%>
    #
    # This function expects a block which will be the css style rules you
    # wish to add to the page. It can be any valid css text.
    #
    def stylesheet(*args, &block)
      if block_given?
        content = capture(&block)
        content_for(:stylesheet_data) { content }
      end
    end

    # Adds style sheet files to the head section of a page.
    #
    # The intent of this function is to simplify your view code when you need
    # special style sheets for a particular page.
    # This function may be called as many times as desired, the style sheets
    # are added in the order they are called.
    #
    # Assumes that there is yield call in the <head> section of your layout
    # like this:
    #   <%= yield :stylesheet_list %>
    #
    # All of the accumulated style sheets are added, in the order they were
    # called when the page is generated.
    #
    # === Usage:
    #   <%- stylesheets 'stylesheetname' -%>
    # or
    #   <%- stylesheets ['stylesheetname1', 'stylesheetname2', ...] -%>
    #
    # The function takes either a string or and array of strings, and you
    # may use an string that is valid for the +stylesheet_link_tag+ function.
    # Be sure to include any paths for the file you wish to add.
    #
    def stylesheets(*args)
      items = args.class == Array ? args : args.to_a
      items.each {|item|
        content_for(:stylesheet_list) { stylesheet_link_tag item }
      }
    end

  end
end

ActionView::Base.send :include, MsTools::HeadHelpers
