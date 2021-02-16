import 'lightgallery'

// Had to modify this lg extension to add lazy loading to thumbnails
import './lg-thumbnail-modified'

import 'lg-fullscreen'
import 'lg-hash'
import '../stylesheets/_gallery.sass'

$(document).ready(function() {
  $('#lightgallery').lightGallery({
    thumbnail: true,
    thumbWidth: 100,
    thumbContHeight: 160,
    fullScreen: true,
  });
});
