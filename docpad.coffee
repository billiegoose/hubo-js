# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration
docpadConfig = {

  # Configure Plugins
  # Should contain the plugin short names on the left, and the configuration to pass the plugin on the right
  plugins:  # example
    jade:
      jadeOptions:
        basedir: 'src/layouts'
        pretty: on
    coffeescript:
      compileOptions:
        bare: on
        header: on

  # =================================
  # DocPad Events

  # Here we can define handlers for events that DocPad fires
  # You can find a full listing of events on the DocPad Wiki
  events:

    renderDocument: (opts,next) ->
      {extension, templateData, file, content} = opts

      path = require('path')

      compute = (from, to) ->
        return (path.relative(path.dirname(from), to) || '.').replace("\\","/") + '/'

      relativizeCSS = (source, relativeRoot) ->
        return (source
          .replace(/(url\(['"])\/(?!\/)/g, "$1"+relativeRoot)
          .replace(/\{local_root\}/g, relativeRoot))

      relativizeHTML = (source, relativeRoot) ->
        return (source
          .replace(/(href=["'])\/(?!\/)/g, '$1'+relativeRoot)
          .replace(/(src=["'])\/(?!\/)/g, '$1'+relativeRoot)
          .replace(/\{local_root\}/g, relativeRoot))

      if file.type is 'document' 
        root = @docpad.getConfig().outPath
        relativeRoot = compute(file.attributes.outPath, root)
        switch extension
          when 'html'
            opts.content = relativizeHTML(content,relativeRoot)
          when 'css'
            opts.content = relativizeCSS(content,relativeRoot)

      return next()
      
      # Chain
      @
}

# Export the DocPad Configuration
module.exports = docpadConfig