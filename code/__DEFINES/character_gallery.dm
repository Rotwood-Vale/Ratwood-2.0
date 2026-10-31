/// Headshot zoom in percent at its smallest, where the picture just covers its square frame
#define HEADSHOT_ZOOM_MIN 100
/// Headshot zoom in percent at its largest
#define HEADSHOT_ZOOM_MAX 300
/// Headshot position on either axis at its largest, in percent of the picture that overflows the frame
#define HEADSHOT_POSITION_MAX 100
/// Headshot position on either axis by default, which centres the picture
#define HEADSHOT_POSITION_DEFAULT 50

/// OOC extra image width at its smallest, in percent of the flavour text column
#define OOC_EXTRA_SIZE_MIN 25
/// OOC extra image width at its largest and by default, in percent of the flavour text column
#define OOC_EXTRA_SIZE_MAX 100

/// Images an art gallery holds at most
#define IMAGE_GALLERY_MAX 4
/// Characters an image link may have at most
#define IMAGE_LINK_MAX_LENGTH 512
/// How long a Character Gallery prompt or confirmation stays open before it closes itself
#define CHARACTER_GALLERY_PROMPT_TIMEOUT (2 MINUTES)
