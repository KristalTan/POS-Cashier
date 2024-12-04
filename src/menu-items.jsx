// assets
import NavigationOutlinedIcon from '@mui/icons-material/NavigationOutlined';
import HomeOutlinedIcon from '@mui/icons-material/HomeOutlined';
import AccountTreeOutlinedIcon from '@mui/icons-material/AccountTreeOutlined';
import AppsOutlinedIcon from '@mui/icons-material/AppsOutlined';
import ContactSupportOutlinedIcon from '@mui/icons-material/ContactSupportOutlined';
import BlockOutlinedIcon from '@mui/icons-material/BlockOutlined';
import ChromeReaderModeOutlinedIcon from '@mui/icons-material/ChromeReaderModeOutlined';
import HelpOutlineOutlinedIcon from '@mui/icons-material/HelpOutlineOutlined';
import ArrowRightIcon from '@mui/icons-material/ArrowRight';
import AssessmentOutlinedIcon from '@mui/icons-material/AssessmentOutlined';
import SettingsOutlinedIcon from '@mui/icons-material/SettingsOutlined';
import TocOutlinedIcon from '@mui/icons-material/TocOutlined';
import BorderColorOutlinedIcon from '@mui/icons-material/BorderColorOutlined';
import PaidOutlinedIcon from '@mui/icons-material/PaidOutlined';
import TableBarOutlinedIcon from '@mui/icons-material/TableBarOutlined';
const icons = {
  NavigationOutlinedIcon: NavigationOutlinedIcon,
  HomeOutlinedIcon: HomeOutlinedIcon,
  ChromeReaderModeOutlinedIcon: ChromeReaderModeOutlinedIcon,
  HelpOutlineOutlinedIcon: HelpOutlineOutlinedIcon,
  BorderColorOutlinedIcon: BorderColorOutlinedIcon,
  AccountTreeOutlinedIcon: AccountTreeOutlinedIcon,
  BlockOutlinedIcon: BlockOutlinedIcon,
  AppsOutlinedIcon: AppsOutlinedIcon,
  ContactSupportOutlinedIcon: ContactSupportOutlinedIcon,
  ArrowRightIcon: ArrowRightIcon,
  AssessmentOutlinedIcon:AssessmentOutlinedIcon,
  SettingsOutlinedIcon:SettingsOutlinedIcon,
  TocOutlinedIcon:TocOutlinedIcon,
  PaidOutlinedIcon:PaidOutlinedIcon,
  TableBarOutlinedIcon:TableBarOutlinedIcon,
};

// ==============================|| MENU ITEMS ||============================== //

// eslint-disable-next-line
export default {
  items: [
    // {
    //   id: 'navigation',
    //   type: 'group',
    //   icon: icons['NavigationOutlinedIcon'],
    //   children: [
    //     {
    //       id: 'dashboard',
    //       title: 'Dashboard',
    //       type: 'item',
    //       icon: icons['HomeOutlinedIcon'],
    //       url: '/dashboard/default'
    //     }
    //   ]
    // },
    {
      id: 'pages',
      title: 'Pos Services',
      type: 'group',
      icon: icons['NavigationOutlinedIcon'],
      children: [
            {
              id: 'table',
              title: 'Table Location',
              type: 'item',
              url: '/table',
              icon: icons['TableBarOutlinedIcon'],
            },
        
            {
              id: 'order',
              title: 'Order',
              type: 'item',
              url: '/order',
              icon: icons['BorderColorOutlinedIcon'],
            },
            {
              id: 'payment',
              title: 'Payment & Billing',
              type: 'item',
              url: '/payment',
              icon: icons['PaidOutlinedIcon'],
            },
           
            {
              id: 'history',
              title: 'Order History',
              type: 'item',
              url: '/history',
              icon: icons['TocOutlinedIcon'],
            }
          
      ]
    },
    
    
  ]
};
