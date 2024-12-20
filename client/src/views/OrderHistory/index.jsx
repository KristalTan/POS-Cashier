import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import {
  Card,
  CardContent,
  Grid,
  Typography,
  Button,
  Divider,
  Box,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TextField,
} from '@mui/material';

// Project imports
import Breadcrumb from 'component/Breadcrumb';

// const fetchOrderHistory = async (startDate, endDate) => {
//   const response = await fetch(`/api/order-history?startDate=${startDate}&endDate=${endDate}`);
//   if (!response.ok) {
//     throw new Error('Failed to fetch order history');
//   }
//   return response.json();
// };
const item = [
  {
    order_trans_id: '000001',
    doc_no: 'DOC001',
    modified_on: '2024-11-20 14:00:00',
    modified_by: 'Ayam',
    tr_type_desc: 'E-Wallet',
    tr_status: 'Paid',
    table_no: 'T1',
    room_no: 'R101',
    amt: 150.25,
  },
  {
    order_trans_id: '000012',
    doc_no: 'DOC002',
    modified_on: '2024-11-13 10:30:00',
    modified_by: 'Ayam',
    tr_type_desc: 'Cash',
    tr_status: 'Paid',
    table_no: 'T2',
    room_no: 'R102',
    amt: 75.50,
  },
  {
    order_trans_id: '000023',
    doc_no: 'DOC003',
    modified_on: '2024-11-01 12:15:00',
    modified_by: 'Ayam',
    tr_type_desc: 'Debit Card',
    tr_status: 'Paid',
    table_no: 'T3',
    room_no: 'R103',
    amt: 200.00,
  },
];

const OrderHistory = () => {
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [orderData, setOrderData] = useState([]);

  // Filter mock data based on date range
  const filterData = (startDate, endDate) => {
    const start = new Date(startDate);
    const end = new Date(endDate);

    return item.filter(order => {
      const orderDate = new Date(order.modified_on.split(' ')[0]);
      return orderDate >= start && orderDate <= end;
    });
  };

  // Fetch data automatically with default date range on mount
  useEffect(() => {
    const today = new Date().toISOString().split('T')[0]; // Current date
    setStartDate(today);
    setEndDate(today);

    // Filter mock data for the current date
    const filteredData = filterData(today, today);
    setOrderData(filteredData);
  }, []);

  const handleSubmit = () => {
    // Filter mock data based on selected dates
    const filteredData = filterData(startDate, endDate);
    setOrderData(filteredData);
  };

  return (
    <>
      {/* Breadcrumb */}
      <Breadcrumb>
        <Typography
          component={Link}
          to="/"
          variant="subtitle2"
          color="inherit"
          className="link-breadcrumb"
        >
          Home
        </Typography>
        <Typography variant="subtitle2" color="primary" className="link-breadcrumb">
          Order History
        </Typography>
      </Breadcrumb>

      {/* Date Filter */}
      <Card sx={{ mb: 2 }}>
        <CardContent>
          <Grid container spacing={2}>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                label="Start Date"
                type="date"
                value={startDate}
                onChange={e => setStartDate(e.target.value)}
                InputLabelProps={{ shrink: true }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <TextField
                fullWidth
                label="End Date"
                type="date"
                value={endDate}
                onChange={e => setEndDate(e.target.value)}
                InputLabelProps={{ shrink: true }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4} display="flex" alignItems="center">
              <Button variant="contained" onClick={handleSubmit}>
                SEARCH
              </Button>
            </Grid>
          </Grid>
        </CardContent>
      </Card>

      {/* Order History Table */}
      <TableContainer component={Card}>
        <Table>
          <TableHead>
            <TableRow>
            <TableCell>Order ID</TableCell>
            <TableCell align="center">Document No</TableCell>
            <TableCell align="center">Modified On</TableCell>
            <TableCell align="center">Modified By</TableCell>
            <TableCell align="center">Transaction Type</TableCell>
            <TableCell align="center">Status</TableCell>
            <TableCell align="center">Table No</TableCell>
            <TableCell align="center">Room No</TableCell>
            <TableCell align="right">Amount</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {orderData.length > 0 ? (
              orderData.map(order => (
                <TableRow key={order.order_trans_id}>
                <TableCell>{order.order_trans_id}</TableCell>
                <TableCell align="center">{order.doc_no}</TableCell>
                <TableCell align="center">{order.modified_on}</TableCell>
                <TableCell align="center">{order.modified_by}</TableCell>
                <TableCell align="center">{order.tr_type_desc}</TableCell>
                <TableCell align="center">{order.tr_status}</TableCell>
                <TableCell align="center">{order.table_no}</TableCell>
                <TableCell align="center">{order.room_no}</TableCell>
                <TableCell align="right">RM {order.amt.toFixed(2)}</TableCell>
              </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={9} align="center">
                  No Data Found
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </TableContainer>
    </>
  );
};

export default OrderHistory;