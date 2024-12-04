import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import {
  Card,
  CardContent,
  Grid,
  Typography,
  Button,
  IconButton,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Divider,
  Box,
  Modal,
  TextField
} from '@mui/material';
import DeleteIcon from '@mui/icons-material/Delete';
import Breadcrumb from 'component/Breadcrumb';
import { gridSpacing } from 'config.js';

const OrderData = [
  {
    order_trans_id: '000001',
    doc_no: 'DOC001',
    modified_on: '2024-11-13 14:00:00',
    modified_by: 'Ayam',
    tr_status: 'Pending',
    table_no: 'T1',
    room_no: 'R101',
    amt: 150.25,
  },
  {
    order_trans_id: '000012',
    doc_no: 'DOC002',
    modified_on: '2024-11-27 10:30:00',
    modified_by: 'Ayam',
    tr_status: 'Pending',
    table_no: 'T2',
    room_no: 'R102',
    amt: 75.50,
  },
  {
    order_trans_id: '000023',
    doc_no: 'DOC003',
    modified_on: '2024-11-30 12:15:00',
    modified_by: 'Ayam',
    tr_status: 'Pending',
    table_no: 'T3',
    room_no: 'R103',
    amt: 200.00,
  },
];

const OrderItemData = [
  {
    order_trans_id: '000001',
    order_trans_item_line_id: '1',
    modified_on: '2024-11-28 12:15:00',
    modified_by: 'Alice Brown',
    tr_date: '2024-11-28',
    tr_type: 'Item Purchase',
    tr_status: 'Pending',
    doc_no: 'DOC003',
    product_id: 'p001',
    product_desc: 'Pizza',
    qty: 2,
    sell_price: 25.0,
    amt: 50.0,
    tax_code1: 'GST',
    tax_pct1: 6.0,
    tax_amt1_calc: 3.0,
    tax_code2: null,
    tax_pct2: null,
    tax_amt2_calc: null,
    pymt_mode_id: 'pm001',
    pymt_mode_desc: 'Cash',
  },
  {
    order_trans_id: '000001',
    order_trans_item_line_id: '2',
    modified_on: '2024-11-28 12:15:00',
    modified_by: 'Alice Brown',
    tr_date: '2024-11-28',
    tr_type: 'Item Purchase',
    tr_status: 'Pending',
    doc_no: 'DOC003',
    product_id: 'p002',
    product_desc: 'Pasta',
    qty: 1,
    sell_price: 30.0,
    amt: 30.0,
    tax_code1: 'GST',
    tax_pct1: 6.0,
    tax_amt1_calc: 1.8,
    tax_code2: null,
    tax_pct2: null,
    tax_amt2_calc: null,
    pymt_mode_id: 'pm001',
    pymt_mode_desc: 'Cash',
  },
  {
    order_trans_id: '000012',
    order_trans_item_line_id: '1',
    modified_on: '2024-11-28 12:15:00',
    modified_by: 'Alice Brown',
    tr_date: '2024-11-28',
    tr_type: 'Item Purchase',
    tr_status: 'Pending',
    doc_no: 'DOC004',
    product_id: 'p003',
    product_desc: 'Burger',
    qty: 3,
    sell_price: 20.0,
    amt: 60.0,
    tax_code1: 'GST',
    tax_pct1: 6.0,
    tax_amt1_calc: 3.6,
    tax_code2: null,
    tax_pct2: null,
    tax_amt2_calc: null,
    pymt_mode_id: 'pm002',
    pymt_mode_desc: 'Card',
  },
];

const PaymentBillings = () => {
  const [selectedOrder, setSelectedOrder] = useState(null);
  const [itemDetails, setItemDetails] = useState([]);
  const [modalOpen, setModalOpen] = useState(false);
  const [selectedItem, setSelectedItem] = useState(null);
  const [discount, setDiscount] = useState(0);

  const handleRowClick = (order) => {
    setSelectedOrder(order);
    setItemDetails(OrderItemData.filter((item) => item.order_trans_id === order.order_trans_id));
  };

  const handleOpenModal = (item = null) => {
    setSelectedItem(item);
    setModalOpen(true);
  };

  const handleCloseModal = () => {
    setModalOpen(false);
    setSelectedItem(null);
  };

  const handleConfirmVoid = () => {
    // if (selectedItem) {
    //   alert(`Void Item functionality triggered for item ${selectedItem.order_trans_item_line_id}!`);
    // } else {
    //   alert('Void Bill functionality triggered!');
    // }
    handleCloseModal();
  };

  const handleSplitBill = () => {
    // alert('Split Bill functionality triggered!');
    // Add logic for splitting the bill
  };

  const calculateTotalAmount = () => {
    const totalAmount = itemDetails.reduce((total, item) => total + item.amt, 0);
    const serviceCharge = totalAmount * 0.06;
    const tax = (totalAmount + serviceCharge) * 0.08;
    const discountAmount = totalAmount * (discount / 100);
    const total = totalAmount + serviceCharge + tax - discountAmount;
    return {
      totalAmount: totalAmount.toFixed(2),
      serviceCharge: serviceCharge.toFixed(2),
      tax: tax.toFixed(2),
      discountAmount: discountAmount.toFixed(2),
      total: total.toFixed(2),
    };
  };

  const handleOverridePriceChange = (index, value) => {
    setItemDetails((prevDetails) => {
      const updatedDetails = [...prevDetails];
      updatedDetails[index].sell_price = parseFloat(value) || 0;
      updatedDetails[index].amt = updatedDetails[index].sell_price * updatedDetails[index].qty;
      return updatedDetails;
    });
  };

  return (
    <>
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
          Payment and Billings
        </Typography>
      </Breadcrumb>

      <Grid container spacing={2} padding="0px">
        {/* Left Table */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6">Orders</Typography>
              <Divider sx={{ my: 1 }} />
              <TableContainer>
                <Table>
                  <TableHead>
                    <TableRow>
                      <TableCell>Order ID</TableCell>
                      <TableCell align="center">Table No</TableCell>
                      <TableCell align="center">Status</TableCell>
                      <TableCell align="center">Amount</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {OrderData.map((order) => (
                      <TableRow
                        key={order.order_trans_id}
                        hover
                        onClick={() => handleRowClick(order)}
                        style={{ cursor: 'pointer' }}
                      >
                        <TableCell>{order.order_trans_id}</TableCell>
                        <TableCell align="center">{order.table_no}</TableCell>
                        <TableCell align="center">{order.tr_status}</TableCell>
                        <TableCell align="center">RM {order.amt.toFixed(2)}</TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </TableContainer>
            </CardContent>
          </Card>
        </Grid>

        {/* Right Container */}
        <Grid item xs={12} md={6}>
          {selectedOrder && (
            <Card>
              <CardContent>
                <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <Typography variant="h6">Order Details</Typography>
                  <Box sx={{ display: 'flex', gap: 2 }}>
                    <Button variant="contained" color="error" onClick={() => handleOpenModal()}>
                      Void Bill
                    </Button>
                    <Button variant="contained" color="primary" onClick={handleSplitBill}>
                      Split Bill
                    </Button>
                  </Box>
                </Box>
                <Divider sx={{ my: 1 }} />
                <TableContainer>
                  <Table>
                    <TableHead>
                      <TableRow>
                        <TableCell>Product</TableCell>
                        <TableCell align="center">Qty</TableCell>
                        <TableCell align="center">Price</TableCell>
                        <TableCell align="center">Amount</TableCell>
                        {/* <TableCell align="center">Override Price</TableCell> */}
                        <TableCell align="center">Action</TableCell>
                      </TableRow>
                    </TableHead>
                    <TableBody>
                      {itemDetails.map((item, index) => (
                        <TableRow key={item.order_trans_item_line_id}>
                          <TableCell>{item.product_desc}</TableCell>
                          <TableCell align="center">{item.qty}</TableCell>
                          <TableCell align="center">
                            <TextField
                              type="number"
                              value={item.sell_price.toFixed(2)}
                              onChange={(e) => handleOverridePriceChange(index, e.target.value)}
                              fullWidth
                            />
                          </TableCell>
                          <TableCell align="center">RM {item.amt.toFixed(2)}</TableCell>
                          
                          <TableCell align="center">
                            <IconButton
                              color="error"
                              onClick={() => handleOpenModal(item)}
                            >
                              <DeleteIcon />
                            </IconButton>
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </TableContainer>
                <Box sx={{ my: 2 }}>
                  <Typography variant="h6" align="right">Service Charge (6%): RM{calculateTotalAmount().serviceCharge}</Typography>
                  <Typography variant="h6" align="right">Tax SST (8%): RM{calculateTotalAmount().tax}</Typography>
                  <TextField
                    label="Discount (%)"
                    type="number"
                    value={discount}
                    onChange={(e) => setDiscount(parseFloat(e.target.value) || 0)}
                    fullWidth
                    sx={{ my: 1 }}
                  />
                  <Typography variant="h6" align="right">Discount Amount: RM{calculateTotalAmount().discountAmount}</Typography>
                  <Typography variant="h6" align="right">Total Amount: RM{calculateTotalAmount().total}</Typography>
                </Box>
                <Button
                  variant="contained"
                  fullWidth
                  sx={{
                    backgroundColor: "#FFB000",
                    color: "#000",
                    '&:hover': {
                      backgroundColor: "#F7E6C4",
                    }
                  }}
                >
                  PAY BILL
                </Button>
              </CardContent>
            </Card>
          )}
        </Grid>
      </Grid>

      {/* Confirmation Modal */}
      <Modal open={modalOpen} onClose={handleCloseModal}>
        <Box
          sx={{
            position: 'absolute',
            top: '50%',
            left: '50%',
            transform: 'translate(-50%, -50%)',
            width: 400,
            bgcolor: 'background.paper',
            // border: '2px solid #000',
            boxShadow: 24,
            borderRadius: 3,
            p: 4,
          }}
        >
          <Typography variant="h5" component="h2">
            Confirm Void {selectedItem ? 'Item' : 'Bill'}
          </Typography>
          <Typography sx={{ mt: 2 }}>
            Are you sure you want to void this {selectedItem ? 'item' : 'bill'}?
          </Typography>
          <Box sx={{ mt: 3, display: 'flex', justifyContent: 'flex-end', gap: 2 }}>
            <Button variant="outlined" onClick={handleCloseModal}>Cancel</Button>
            <Button variant="contained" color="error" onClick={handleConfirmVoid}>Confirm</Button>
          </Box>
        </Box>
      </Modal>
    </>
  );
};

export default PaymentBillings;
