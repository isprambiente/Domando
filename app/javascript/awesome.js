//import '@fortawesome/fontawesome-free/js/solid'
import { config, library, dom } from '@fortawesome/fontawesome-svg-core'

// Change the config to fix the flicker
config.mutateApproach = 'sync'

// Import required icons
import {
  faBan,
  faBars,
  faBook,
  faBug,
  faCheck,
  faChevronDown,
  faCog,
  faCogs,
  faDownload,
  faEdit,
  faExclamationCircle,
  faExternalLinkAlt,
  faFilter,
  faHome,
  faImage,
  faImages,
  faInfoCircle,
  faLaptop,
  faLink,
  faList,
  faLock,
  faPlus,
  faPrint,
  faQuestionCircle,
  faLifeRing,
  faSave,
  faSearch,
  faSearchPlus,
  faSignInAlt,
  faSignOutAlt,
  faSort,
  faSortDown,
  faSortUp,
  faStar,
  faTimes,
  faTrash,
  faUnlock,
  faUpload,
  faUser,
  faUserCog,
  faUsers
} from '@fortawesome/free-solid-svg-icons'

import { faStar as farFaStar } from '@fortawesome/free-regular-svg-icons'

// add incons to library
library.add(
  faBan,
  faBars,
  faBook,
  faBug,
  faCheck,
  faChevronDown,
  faCog,
  faCogs,
  faDownload,
  faEdit,
  faExclamationCircle,
  faExternalLinkAlt,
  faFilter,
  faHome,
  faImage,
  faImages,
  faInfoCircle,
  faLaptop,
  faLink,
  faList,
  faLock,
  faPlus,
  faPrint,
  faQuestionCircle,
  faLifeRing,
  faSave,
  faSearch,
  faSearchPlus,
  faSignInAlt,
  faSignOutAlt,
  faSort,
  faSortDown,
  faSortUp,
  faStar,
  farFaStar,
  faTimes,
  faTrash,
  faUnlock,
  faUpload,
  faUser,
  faUserCog,
  faUsers
)

// watch hatml
dom.watch()
