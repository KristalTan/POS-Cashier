import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';

// material-ui
import { Card, CardContent, Grid, Typography, Button, Divider, Box, Tab, IconButton, MenuItem, FormControl, Popover, Select, Radio, RadioGroup, FormControlLabel, Checkbox, FormGroup } from '@mui/material';
import { TabContext, TabList } from '@mui/lab';
import AddIcon from '@mui/icons-material/Add';
import RemoveIcon from '@mui/icons-material/Remove';
import CloseIcon from '@mui/icons-material/Close';

// project import
import Breadcrumb from 'component/Breadcrumb';
import { gridSpacing } from 'config.js';

const Order = () => {
  const [orderedItems, setOrderedItems] = useState([]);
  const [selectedModifiers, setSelectedModifiers] = useState({});
  const [modifierAnchorEl, setModifierAnchorEl] = useState(null);
  const [currentItem, setCurrentItem] = useState(null);

  // Function to add an item to the order by its id
  const addToOrder = (item, modifiers) => {
    setOrderedItems(prevItems => {
      const existingItem = prevItems.find(orderedItem => orderedItem.product_id === item.product_id);
      if (existingItem) {
        return prevItems.map(orderedItem =>
          orderedItem.product_id === item.product_id
            ? { ...orderedItem, quantity: orderedItem.quantity + 1, modifiers }
            : orderedItem
        );
      }
      return [...prevItems, { ...item, quantity: 1, modifiers }];
    });
  };

  // Function to remove an item from the order if the quantity is zero
  const handleRemoveItem = (product_id) => {
    setOrderedItems(prevItems => prevItems.filter(item => item.product_id !== product_id));
  };

  // Function to update the quantity of an item
  const updateQuantity = (product_id, newQuantity) => {
    setOrderedItems(prevItems =>
      prevItems.map(item =>
        item.product_id === product_id ? { ...item, quantity: newQuantity } : item
      )
    );
  };

  const getTotalPrice = () => {
    return orderedItems.reduce((total, item) => total + item.sell_price * item.quantity, 0);
  };

  const handleModifierChange = (modifierGroupName, optionId, isChecked) => {
    setSelectedModifiers(prevModifiers => {
      const updatedModifiers = { ...prevModifiers };
      if (!updatedModifiers[currentItem.product_id]) {
        updatedModifiers[currentItem.product_id] = {};
      }
      if (!updatedModifiers[currentItem.product_id][modifierGroupName]) {
        updatedModifiers[currentItem.product_id][modifierGroupName] = [];
      }

      if (isChecked) {
        updatedModifiers[currentItem.product_id][modifierGroupName].push(optionId);
      } else {
        updatedModifiers[currentItem.product_id][modifierGroupName] = updatedModifiers[currentItem.product_id][modifierGroupName].filter(id => id !== optionId);
      }

      return updatedModifiers;
    });
  };

  const handlePlaceOrder = () => {
    alert('Order placed successfully!');
    window.location.reload();
  };

  const handleOpenModifiers = (event, item) => {
    if (item.modifiers && item.modifiers.length > 0) {
      setModifierAnchorEl(event.currentTarget);
      setCurrentItem(item);

      // Auto-fill default modifiers
      const defaultModifiers = {};
      item.modifiers.forEach((modifier) => {
        const defaultOptions = modifier.options.filter(option => option.is_default === 1);
        if (defaultOptions.length > 0) {
          defaultModifiers[modifier.modifier_group_name] = defaultOptions.map(option => option.modifier_option_id);
        }
      });

      setSelectedModifiers(prevModifiers => ({
        ...prevModifiers,
        [item.product_id]: defaultModifiers,
      }));
    } else {
      addToOrder(item, {});
    }
  };

  const handleCloseModifiers = () => {
    setModifierAnchorEl(null);
  };

  const handleAddWithModifiers = () => {
    if (currentItem) {
      addToOrder(currentItem, selectedModifiers[currentItem.product_id] || {});
      setCurrentItem(null);
      setModifierAnchorEl(null);
    }
  };

  const open = Boolean(modifierAnchorEl);

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
          Order Page
        </Typography>
      </Breadcrumb>

      <Grid container spacing={gridSpacing} padding="0px">
        {/* Grid for Menu Category */}
        <Grid item xl={9} lg={8} sm={8} xs={12}>
          <Card
            sx={{
              width: '100%',
              margin: 'auto',
              display: 'flex',
              flexDirection: 'column',
            }}
          >
            <MenuCategory handleOpenModifiers={handleOpenModifiers} />
          </Card>
        </Grid>

        <Grid item xl={3} lg={4} sm={4} md={4} xs={12}>
          <Card
            sx={{
              width: '100%',
              display: 'flex',
              flexDirection: 'column',
              justifyContent: 'space-between', // Ensure space between content and bottom
              overflow: 'hidden',
              height: {
                xs: '440px',
                sm: '490px',
                md: '600px',
                lg: '640px',
                xl: '700px',
                xxl: '1095px'
              },
            }}
          >
            <OrderDetails />

            {/* Ordered items scrollable section */}
            <Box sx={{ flexGrow: 1, overflowY: 'auto', padding: '0px' }}>
              {orderedItems.map((item) => (
                <MenuOrdered
                  key={item.product_id}
                  product_id={item.product_id}
                  product_desc={item.product_desc}
                  sell_price={item.sell_price}
                  quantity={item.quantity}
                  onRemoveItem={handleRemoveItem}
                  updateQuantity={updateQuantity}
                  modifiers={item.modifiers}
                />
              ))}
            </Box>

            {/* Divider */}
            <Divider />

            {/* Fixed total price and place order button at the bottom */}
            <Box>
              {/* Total Price */}
              <CardContent>
                <Typography variant="h6" align="right">
                  Total: RM {getTotalPrice().toFixed(2)}
                </Typography>
              </CardContent>

              {/* Place Order Button */}
              <CardContent>
                <Button
                  variant="contained"
                  fullWidth
                  onClick={handlePlaceOrder}
                  disabled={orderedItems.length === 0} // Disable if no items in order
                  sx={{
                    backgroundColor: "#FFB000",
                    color: "#000",
                    '&:hover': {
                      backgroundColor: "#F7E6C4",
                    }
                  }}
                >
                  Place Order
                </Button>
              </CardContent>
            </Box>
          </Card>
        </Grid>
      </Grid>

      {/* Popover for Modifier Selection */}
      {currentItem && currentItem.modifiers && (
        <Popover
          open={open}
          anchorEl={modifierAnchorEl}
          onClose={handleCloseModifiers}
          anchorOrigin={{
            vertical: 'bottom',
            horizontal: 'center',
          }}
          transformOrigin={{
            vertical: 'top',
            horizontal: 'center',
          }}
        >
          <Box p={2} width={300}>
            <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
              <Typography variant="h6" color="#33372C">
                Select Modifiers
              </Typography>
              <IconButton size="small" onClick={handleCloseModifiers}>
                <CloseIcon />
              </IconButton>
            </Box>
            {currentItem.modifiers.map((modifier) => (
              <Box key={modifier.modifier_group_name} my={2}>
                <Typography variant="subtitle1">{modifier.modifier_group_name}</Typography>
                {modifier.sing_c === 1 ? (
                  <RadioGroup
                    value={selectedModifiers[currentItem.product_id]?.[modifier.modifier_group_name]?.[0] || ''}
                    onChange={(e) => handleModifierChange(modifier.modifier_group_name, e.target.value, true)}
                  >
                    {modifier.options.map((option) => (
                      <FormControlLabel
                        key={option.modifier_option_id}
                        value={option.modifier_option_id}
                        control={<Radio />}
                        label={`${option.modifier_option_name} (+RM ${option.addon_amt.toFixed(2)})`}
                      />
                    ))}
                  </RadioGroup>
                ) : (
                  <FormGroup>
                    {modifier.options.map((option) => (
                      <FormControlLabel
                        key={option.modifier_option_id}
                        control={
                          <Checkbox
                            checked={selectedModifiers[currentItem.product_id]?.[modifier.modifier_group_name]?.includes(option.modifier_option_id) || false}
                            onChange={(e) => handleModifierChange(modifier.modifier_group_name, option.modifier_option_id, e.target.checked)}
                          />
                        }
                        label={`${option.modifier_option_name} (+RM ${option.addon_amt.toFixed(2)})`}
                      />
                    ))}
                  </FormGroup>
                )}
              </Box>
            ))}
            <Button
              variant="contained"
              fullWidth
              onClick={handleAddWithModifiers}
              sx={{
                mt: 2,
                backgroundColor: "#FFB000",
                color: "#000",
                '&:hover': {
                  backgroundColor: "#F7E6C4",
                },
              }}
            >
              Add
            </Button>
          </Box>
        </Popover>
      )}
    </>
  );
};

const MenuCategory = ({ handleOpenModifiers }) => {
  const [value, setValue] = useState('All');

  const items = [
    {
      product_id: 1,
      product_desc: "Egg Sandwich",
      product_code: "B001",
      category_id: 1,
      product_tag: "morning",
      product_img_path: "/images/breakfast.png",
      supplier_id: 201,
      pricing_type_id: 301,
      cost: 5.00,
      sell_price: 10.00,
      tax_code1: 1,
      amt_include_tax1: 11.00,
      tax_code2: 2,
      amt_include_tax2: 12.00,
      calc_tax2_after_tax1: 1,
      is_in_use: 1,
      display_seq: 12,
      is_enable_kitchen_printer: 1,
      is_allow_modifier: 1,
      is_enable_track_stock: 1,
      is_popular_item: 1,
      meal_period:5,
      modifiers: [
        {
          modifier_group_name: "Cup Size",
          sing_c: 1,
          mult_c: 0,
          options: [
            { modifier_option_id: "1", modifier_option_name: "Small", addon_amt: 0, is_default: 1 },
            { modifier_option_id: "2", modifier_option_name: "Medium", addon_amt: 1, is_default: 0 },
            { modifier_option_id: "3", modifier_option_name: "Large", addon_amt: 2, is_default: 0 }
          ]
        },
        {
          modifier_group_name: "Ingredient Add On",
          sing_c: 0,
          mult_c: 1,
          options: [
            { modifier_option_id: "4", modifier_option_name: "Extra Spicy", addon_amt: 0.5, is_default: 0 },
            { modifier_option_id: "5", modifier_option_name: "Extra Cheese", addon_amt: 1, is_default: 0 },
            { modifier_option_id: "6", modifier_option_name: "Extra Garlic", addon_amt: 0.75, is_default: 0 }
          ]
        }
      ]
    },
    {
        product_id: 2,
        product_desc: "Nasi Goreng Ayam",
        product_code: "L002",
        category_id: 2,
        product_tag: "afternoon",
        product_img_path: "/images/lunch.png",
        supplier_id: 202,
        pricing_type_id: 302,
        cost: 7.00,
        sell_price: 15.00,
        tax_code1: 1,
        amt_include_tax1: 11.00,
        tax_code2: 2,
        amt_include_tax2: 12.00,
        calc_tax2_after_tax1: 1,
        is_in_use: 1,
        display_seq: 10,
        is_enable_kitchen_printer: 1,
        is_allow_modifier: 1,
        is_enable_track_stock: 1,
        is_popular_item: 1,
        meal_period: 4,
        modifiers: [],

    },
    {
        product_id: 3,
        product_desc: "Chicken Chop with sides",
        product_code: "D003",
        category_id: 3,
        product_tag: "evening",
        product_img_path: "/images/dinner.png",
        supplier_id: 203,
        pricing_type_id: 303,
        cost: 10.00,
        sell_price: 20.00,
        tax_code1: 1,
        amt_include_tax1: 11.00,
        tax_code2: 2,
        amt_include_tax2: 12.00,
        calc_tax2_after_tax1: 1,
        is_in_use: 1,
        display_seq: 8,
        is_enable_kitchen_printer: 1,
        is_allow_modifier: 1,
        is_enable_track_stock: 1,
        is_popular_item: 1,
        meal_period: 3,
        modifiers: [],

    },
    {
        product_id: 4,
        product_desc: "French Fries",
        product_code: "S004",
        category_id: 4,
        product_tag: "snack",
        product_img_path: "/images/snack.png",
        supplier_id: 204,
        pricing_type_id: 304,
        cost: 3.00,
        sell_price: 6.00,
        tax_code1: 1,
        amt_include_tax1: 11.00,
        tax_code2: 2,
        amt_include_tax2: 12.00,
        calc_tax2_after_tax1: 1,
        is_in_use: 0,
        display_seq: 5,
        is_enable_kitchen_printer: 0,
        is_allow_modifier: 0,
        is_enable_track_stock: 1,
        is_popular_item: 0,
        meal_period: 2,
        modifiers: [],

    },
    {
        product_id: 5,
        product_desc: "Chocolate Ice Cream",
        product_code: "DS005",
        category_id: 5,
        product_tag: "dessert",
        product_img_path: "/images/dessert.png",
        supplier_id: 205,
        pricing_type_id: 305,
        cost: 4.00,
        sell_price: 8.00,
        tax_code1: 1,
        amt_include_tax1: 11.00,
        tax_code2: 2,
        amt_include_tax2: 12.00,
        calc_tax2_after_tax1: 1,
        is_in_use: 1,
        display_seq: 15,
        is_enable_kitchen_printer: 1,
        is_allow_modifier: 1,
        is_enable_track_stock: 1,
        is_popular_item: 1,
        meal_period: 1,
        modifiers: [],

    },
    ];

  const category = [
    { category_id: 1, category_desc: "Breakfast", is_in_use: 1, display_seq: 12 },
    { category_id: 2, category_desc: "Lunch", is_in_use: 1, display_seq: 10 },
    { category_id: 3, category_desc: "Dinner", is_in_use: 1, display_seq: 8 },
    { category_id: 4, category_desc: "Snack", is_in_use: 0, display_seq: 5 },
    { category_id: 5, category_desc: "Dessert", is_in_use: 1, display_seq: 15 },
  ];

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  // Function to filter and render MenuCards based on the selected category
  const renderMenuCards = () => {
    const filteredItems = value === 'All' ? items : items.filter(item => item.category_id === category.find(cat => cat.category_desc === value)?.category_id);
  
    return (
      <Box 
        display="grid"
        gridTemplateColumns="repeat(auto-fill, minmax(200px, 1fr))"
        gap="10px"
      >
        {filteredItems.map((item) => (
          <Box
            key={item.product_id}
            backgroundColor={"#F5F5DC"}
            display="flex"
            flexDirection="column"
            sx={{
              '&:hover': {
                border: "2px solid #557C56",
              }
            }}
            onClick={(e) => handleOpenModifiers(e, item)} // Call handleOpenModifiers when clicked
          >
            <Box margin={4}>
              <Typography variant="h7" color={"#557C56"}>
                {item.product_desc}
              </Typography>
              <Typography variant="h6" color={"#7D7C7C"} fontWeight="bold">
                RM {item.sell_price.toFixed(2)}
              </Typography>
            </Box>
          </Box>
        ))}
      </Box>
    );
  };

  return (
    <Box>
      <Box sx={{ width: '100%', typography: 'body1' }}>
        <TabContext value={value}>
          <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
            <TabList
              onChange={handleChange}
              aria-label="menu categories"
              variant="scrollable" // Enable scrolling for tabs
              scrollButtons="auto" // Show scroll buttons automatically when needed
              allowScrollButtonsMobile // Allows scroll buttons on mobile devices
            >            
              <Tab label="All" value="All" />
              {category.map((cat) => (
                <Tab key={cat.category_id} label={cat.category_desc} value={cat.category_desc} />
              ))}
            </TabList>
          </Box>

          {/* Conditionally render MenuCards based on the selected category */}
          <Box 
            sx={{
              p: "10px",
              overflow: 'auto',  // Enable scroll
              height: {
                xs: '400px', // Adjust for small screens
                sm: '440px', // Adjust for screens >= 768px
                md: '580px', // Adjust for screens >= 1024px
                lg: '590px', // Adjust for screens >= 1266px
                xl: '700px', // Adjust for screens >= 1440px
                xxl: '1050px'
              },
              "::-webkit-scrollbar": {
                display: "none", // Hides the scrollbar in Chrome, Safari, and other WebKit browsers
              },
              scrollbarWidth: "none", // Hides the scrollbar in Firefox
            }}
          >
            {renderMenuCards()}
          </Box>
        </TabContext>
      </Box>
    </Box>
  );
};

const MenuOrdered = ({ product_id, product_desc, sell_price, quantity, onRemoveItem, updateQuantity, modifiers }) => {
  const handleAdd = () => {
    updateQuantity(product_id, quantity + 1);
  };

  const handleRemove = () => {
    if (quantity > 1) {
      updateQuantity(product_id, quantity - 1);
    } else {
      onRemoveItem(product_id); // Call the function to remove the item if quantity is 0
    }
  };

  const totalPrice = sell_price * quantity;

  return (
    <Box 
      mx="12px"
      my="4px"
      borderRadius="10px"
      sx={{
        backgroundColor: "#F5F5F5",
        boxShadow: "0px 2px 5px rgba(0, 0, 0, 0.20)",
        position: 'relative'
      }}
    >
      <Box
        mx="20px"
        my="10px"
        display="flex"
        alignItems="center"
        justifyContent="space-between"
      >
        <Box ml="10px">
          <Typography variant="h6" color="#33372C">
            {product_desc}
          </Typography>
          <Typography variant="subtitle2" color="grey">
            RM {totalPrice.toFixed(2)}
          </Typography>
        </Box>

        <Box display="flex" alignItems="center">
          <IconButton 
            size="small"
            onClick={handleRemove}
            sx={{ width: "20px", height: "20px", border: "1px solid #ccc", borderRadius: "25px" }} 
          >
            <RemoveIcon fontSize="small" />
          </IconButton>

          <Typography variant="h6" mx="15px">
            {quantity}
          </Typography>

          <IconButton 
            size="small"
            onClick={handleAdd}
            sx={{ width: "20px", height: "20px", border: "1px solid #ccc", borderRadius: "25px" }} 
          >
            <AddIcon fontSize="small" />
          </IconButton>
        </Box>
      </Box>
    </Box>
  );
};

const OrderDetails = () => {
  const [table, setTable] = useState('Select Table');
  const [dineOption, setDineOption] = useState('Order Type');

  const initialRows = [
    { table_id: 1, table_desc: "A1", table_section_id: 1, qr_code: "not_sure", is_in_use: 1, display_seq: 12 },
    { table_id: 2, table_desc: "A2", table_section_id: 1, qr_code: "not_sure", is_in_use: 1, display_seq: 10 },
    { table_id: 3, table_desc: "A3", table_section_id: 1, qr_code: "not_sure", is_in_use: 1, display_seq: 8 },
    { table_id: 4, table_desc: "A4", table_section_id: 1, qr_code: "not_sure", is_in_use: 0, display_seq: 5 },
    { table_id: 5, table_desc: "A5", table_section_id: 1, qr_code: "not_sure", is_in_use: 1, display_seq: 15 },
  ];

  const handleTableChange = (e) => {
    setTable(e.target.value);
  };

  const handleDineOptionChange = (e) => {
    setDineOption(e.target.value);
  };

  return (
    <Box sx={{ 
        padding: 2, 
        borderBottom: '1px solid #ccc', 
        backgroundColor: 'transparent', 
        margin: '10px',                  
    }}>
      <Typography variant="h4" fontWeight="bold" color="#33372C" gutterBottom 
       sx={{ textAlign: 'center' }}
      >
        Order Details
      </Typography>
      
      <Box sx={{ display: 'flex', gap: "5px" }}>
        <FormControl fullWidth mx="30px" sx={{ borderRadius: '24px', flex: 1 }}>
          <Select value={dineOption} onChange={handleDineOptionChange}
            sx={{
              borderRadius: '24px',
              backgroundColor: '#f5f5f5', 
              width: '100%',
              height: '35px',
            }}
          >
            <MenuItem value="Order Type" disabled>Order Type</MenuItem>
            <MenuItem value="Dine In">Dine In</MenuItem>
            <MenuItem value="Room Service">Room Service</MenuItem>
            <MenuItem value="Take Away">Take Away</MenuItem>
          </Select>
        </FormControl>
        <FormControl fullWidth mx="30px"
          sx={{ borderRadius: "24px", flex: 1 }}>
          <Select value={table} onChange={handleTableChange} 
            sx={{
              borderRadius: '24px', 
              backgroundColor: '#f5f5f5', 
              width: '100%',
              height: '35px',
            }}
          >
            <MenuItem value="Select Table" disabled>Select Table</MenuItem>
            {initialRows.map((row) => (
              <MenuItem key={row.table_id} value={row.table_id}>{row.table_desc}</MenuItem>
            ))}
          </Select>
        </FormControl>

        
      </Box>
    </Box>
  );
};

export default Order;
