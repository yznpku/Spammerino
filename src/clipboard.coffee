Spammerino = window.Spammerino ?= {}
Spammerino.copyToClipboard = (text) ->
  textarea = document.createElement 'textarea'
  textarea.textContent = text
  textarea.style.position = 'fixed'
  document.body.appendChild textarea
  textarea.select()
  try
    document.execCommand 'copy'
  catch e
    console.log 'Failed to copy to clipboard', e
  finally
    document.body.removeChild textarea
