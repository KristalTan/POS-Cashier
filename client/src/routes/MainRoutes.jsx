import React, { lazy } from 'react';

// project import
import MainLayout from 'layout/MainLayout';
import Loadable from 'component/Loadable';

const DashboardDefault = Loadable(lazy(() => import('views/Dashboard/Default')));
const Order = Loadable(lazy(() => import('views/Order')));
const TableLocation = Loadable(lazy(() => import('views/TableLocation')));
const PaymentBillings = Loadable(lazy(() => import('views/PaymentBillings')));
const OrderHistory = Loadable(lazy(() => import('views/OrderHistory')));

// ==============================|| MAIN ROUTES ||============================== //

const MainRoutes = {
  path: '/',
  element: <MainLayout />,
  children: [
    {path: '/',element: <TableLocation/>},
    // {path: '/dashboard/default',element: <DashboardDefault />},
    { path: '/order', element: <Order/> },
    { path: '/table', element: <TableLocation/> },
    { path: '/payment', element: <PaymentBillings/> },
    { path: '/history', element: <OrderHistory/> }


  ]
};

export default MainRoutes;
