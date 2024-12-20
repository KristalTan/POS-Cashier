import React, { lazy } from 'react';

// project import
import MainLayout from 'layout/MainLayout';
import Loadable from 'component/Loadable';

const DashboardDefault = Loadable(lazy(() => import('views/Dashboard/Default')));
const Order = Loadable(lazy(() => import('views/Order')));
const Table_Location = Loadable(lazy(() => import('views/Table_Location')));
const PaymentBillings = Loadable(lazy(() => import('views/PaymentBillings')));
const OrderHistory = Loadable(lazy(() => import('views/OrderHistory')));

// ==============================|| MAIN ROUTES ||============================== //

const MainRoutes = {
  path: '/',
  element: <MainLayout />,
  children: [
    {path: '/',element: <Table_Location/>},
    // {path: '/dashboard/default',element: <DashboardDefault />},
    { path: '/order', element: <Order/> },
    { path: '/table', element: <Table_Location/> },
    { path: '/payment', element: <PaymentBillings/> },
    { path: '/history', element: <OrderHistory/> }


  ]
};

export default MainRoutes;
