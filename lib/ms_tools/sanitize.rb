module MsTools
  module MsSanitize

    module Config
      DEFAULT    = Sanitize::Config::DEFAULT.update({:remove_contents => ['script', 'embed', 'iframe']})
      BASIC      = Sanitize::Config::BASIC.update({:remove_contents => ['script', 'embed', 'iframe']})
      RESTRICTED = Sanitize::Config::RESTRICTED.update({:remove_contents => ['script', 'embed', 'iframe']})
      RELAXED    = Sanitize::Config::RELAXED.update({:remove_contents => ['script', 'embed', 'iframe']})
      EXTENDED   = {
        :elements => [
          'a', 'b', 'blockquote', 'br', 'caption', 'cite', 'code', 'col',
          'colgroup', 'dd', 'dl', 'dt', 'em', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
          'hr', 'i', 'img', 'li', 'ol', 'p', 'pre', 'q', 'small', 'strike',
          'strong', 'sub', 'sup', 'table', 'tbody', 'td', 'tfoot', 'th', 'thead',
          'tr', 'u', 'ul'],

        :attributes => {
          'a'          => ['class', 'href', 'title'],
          'blockquote' => ['class', 'cite'],
          'br'         => ['class'],
          'code'       => ['class'],
          'col'        => ['class', 'span', 'width'],
          'colgroup'   => ['class', 'span', 'width'],
          'hr'         => ['class'],
          'img'        => ['class', 'align', 'alt', 'height', 'src', 'title', 'width', 'title'],
          'li'         => ['class', 'title'],
          'ol'         => ['class', 'start', 'type'],
          'p'          => ['class', 'title'],
          'q'          => ['class', 'cite'],
          'table'      => ['border', 'class', 'cellspacing', 'cellpadding', 'summary', 'width'],
          'td'         => ['abbr', 'axis', 'class', 'colspan', 'rowspan', 'width', 'title'],
          'th'         => ['abbr', 'axis', 'class', 'colspan', 'rowspan', 'scope', 'width', 'title'],
          'ul'         => ['class', 'type']
        },

        :protocols => {
          'a'          => {'href' => ['ftp', 'http', 'https', 'mailto', :relative]},
          'blockquote' => {'cite' => ['http', 'https', :relative]},
          'img'        => {'src'  => ['http', 'https', :relative]},
          'q'          => {'cite' => ['http', 'https', :relative]}
        },

        :remove_contents => ['script', 'embed', 'iframe']
      }
    end

    # Returns a sanitized copy of _html_, using the settings in _config_ if
    # specified.
    def msclean(html, options = {})
      config = options.delete(:config) || {}
      radius = options.delete(:radius) || false
      if( radius ) then
        Sanitize.clean(html.gsub(/<r:([a-z0-9 _'"=-]+) \/>/i, '(r:\1 /)'), config).gsub('&#13;',"").gsub(/\(r:([a-z0-9 _'"=-]+) \/\)/i, '<r:\1 />')
      else
        Sanitize.clean(html, config).gsub('&#13;',"")
      end
    end

    # Performs Sanitize#clean in place, returning _html_, or +nil+ if no changes
    # were made.
    def msclean!(html, options = {})
      config = options.delete(:config) || {}
      radius = options.delete(:radius) || false
      if( radius ) then
        Sanitize.clean!(html.gsub(/<r:([a-z0-9 _'"=-]+) \/>/i, '(r:\1 /)'), config).gsub('&#13;',"").gsub(/\(r:([a-z0-9 _'"=-]+) \/\)/i, '<r:\1 />')
      else
        Sanitize.clean!(html, config).gsub('&#13;',"")
      end
    end

    # A sanitizer before filter that walks all parameters before any
    # processing takes place.
    #
    # == Description
    #
    # This is based on the sanitize_params plugin written by Jay Laney, updated
    # by Danny Sofer to work with the Sanitizer module that is now part of
    # the Rails core.
    #
    # The original version of sanitize_params used Rick Olsen's white_list plugin,
    # but as Rick pointed out some time ago, "I recently just refactored a lot of
    # that code into the html tokenizer library. You can now access the classes
    # directly as HTML::Sanitizer, HTML::LinkSanitizer, and HTML::WhiteListSanitizer."
    #
    # Danny Sofer's version of sanitize_params does exactly that. Otherwise,
    # it is unchanged from Jay's original code designed for scrubbing your
    # user input clean.
    #
    # I modified this to work with Ryan Grove's Sanitize gem which is required
    # by this function.
    #
    # == Usage
    # 
    # in application.rb:
    #
    # before_filter :sanitize_params
    #
    # Alternatively, add the filter to your controllers selectively.
    #
    # == Contact
    #
    # The original sanitize_params plugin was written by Jay Laney and is still
    # available at http://code.google.com/p/sanitizeparams/
    #
    # This version was dereived from the forked version tweaked by Danny Sofer,
    # which can be found at http://github.com/sofer/sanitize_params.
    #
    def sanitize_params(params = params)
      params = walk_hash(params) if params
    end

    # Returns a sanitized copy of _html_, using the settings in _config_ if
    # specified.
    def sanitize(html, options = {})
      msclean(html, options)
    end

    # Performs Sanitize#clean in place, returning _html_, or +nil+ if no changes
    # were made.
    def sanitize!(html, options = {})
      msclean!(html, options)
    end

  private

    def walk_hash(hash)
      hash.keys.each do |key|
        if hash[key].is_a? String
          hash[key] = sanitize(hash[key])
        elsif hash[key].is_a? Hash
          hash[key] = walk_hash(hash[key])
        elsif hash[key].is_a? Array
          hash[key] = walk_array(hash[key])
        end
      end
      hash
    end

    def walk_array(array)
      array.each_with_index do |el,i|
        if el.is_a? String
          array[i] = sanitize(el)
        elsif el.is_a? Hash
          array[i] = walk_hash(el)
        elsif el.is_a? Array
          array[i] = walk_array(el)
        end
      end
      array
    end

  end
end

ActionController::Base.send :include, MsTools::MsSanitize
