import 'lightgallery'
import 'lg-thumbnail'
import 'lg-fullscreen'
import '../stylesheets/_gallery.sass'

$(document).ready(function() {
  $('#lightgallery').lightGallery({
    thumbnail: true,
    thumbWidth: 50,
    fullScreen: true,
  });
});
