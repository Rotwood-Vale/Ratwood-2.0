/// Headshot zoom in percent at its smallest, where the picture just covers its square frame
#define HEADSHOT_ZOOM_MIN 100
#define HEADSHOT_ZOOM_MAX 800
/// Headshot position on either axis at its largest, in percent of the picture that overflows the frame
#define HEADSHOT_POSITION_MAX 100
#define HEADSHOT_X_DEFAULT 50
/// 0 rather than 50 like HEADSHOT_X_DEFAULT, so a new headshot's crop starts at the top of the picture where a
/// face usually is. At 50 the default crop takes the middle of a tall picture and cuts the face off
#define HEADSHOT_Y_DEFAULT 0

/// OOC extra image width at its smallest, in percent of the flavour text column
#define OOC_EXTRA_SIZE_MIN 25
#define OOC_EXTRA_SIZE_MAX 100

/// Images an art gallery holds at most. The examine gallery's WHEEL_SPOTS and its seal art in ExamineGalleryArt.scss cover 4, so raising it needs both extended
#define IMAGE_GALLERY_MAX 4
#define IMAGE_BLOCKED_MAX 16
#define IMAGE_LINK_MAX_LENGTH 512
/// Must name the hosts valid_headshot_link() accepts
#define IMAGE_LINK_HOSTS_TEXT "Gyazo, Lensdump, Imgbox, Catbox, ImgBB or File Garden"
#define CHARACTER_GALLERY_PROMPT_TIMEOUT (2 MINUTES)

/// The form ids, which FormId in tgui's CharacterGallery/shared.tsx must match
#define GALLERY_FORM_CHARACTER "character"
#define GALLERY_FORM_GNOLL "gnoll"
/// What starts the name of an NSFW image's var, savefile key or slot, and nothing for a SFW one
#define GALLERY_NSFW_PREFIX(nsfw) ((nsfw) ? "nsfw_" : "")
#define GALLERY_ART_PREFIX(nsfw) ((nsfw) ? "nsfw_art" : "art")
#define GALLERY_EXTRA_SLOT(nsfw) ((nsfw) ? "nsfw_extra" : "extra")
#define GALLERY_REMOVED_POINT(scope) "[scope]_removed"
#define GALLERY_UNDO_CLEAR "clear_all"

#define GALLERY_BACKDROP_NONE "none"
#define GALLERY_BACKDROP_PICTURE "picture"
#define GALLERY_BACKDROP_TAVERN "tavern"

#define GALLERY_CARD_DEFAULT "transparent"

/**
 * Copies headshot framing, the examine backdrop and card backgrounds between owners
 *
 * A macro so the compiler checks every name against each owner's own type, which a proc taking
 * the four unrelated owner types could not. copy_target and copy_source must be plain names, src included.
 * headshot_frame_chat is copied on its own line beside it, where the owner has one.
 */
#define COPY_GALLERY_PRESENTATION(copy_target, copy_source) \
	copy_target.headshot_zoom = copy_source.headshot_zoom;\
	copy_target.headshot_x = copy_source.headshot_x;\
	copy_target.headshot_y = copy_source.headshot_y;\
	copy_target.headshot_framed = copy_source.headshot_framed;\
	copy_target.image_backdrop = copy_source.image_backdrop;\
	copy_target.card_backgrounds = deepCopyList(copy_source.card_backgrounds);

/// Examine Image Gallery easter egg of a cat on the tavern's table, its figure id in the gallery's backdrops.ts
#define GALLERY_FIGURE_TAVERN_CAT "cat"
/// Examine Image Gallery easter egg of a dog peeking over the tavern's table in the cat's place, its figure id in the gallery's backdrops.ts
#define GALLERY_FIGURE_TAVERN_DOG "dog"
/// Percent chance for each opening of an examine panel that the tavern shows one of its figures
#define GALLERY_TAVERN_FIGURE_CHANCE 25
