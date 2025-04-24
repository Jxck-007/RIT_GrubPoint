import React, { useState } from 'react';

const ProfilePage = () => {
    const [userInfo, setUserInfo] = useState({
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '123-456-7890',
    });

    const [orderHistory, setOrderHistory] = useState([
        { id: 1, date: '2023-10-01', items: 'Pizza, Coke', total: '$20', status: 'Delivered' },
        { id: 2, date: '2023-09-25', items: 'Burger, Fries', total: '$15', status: 'Delivered' },
    ]);

    const [paymentMethods, setPaymentMethods] = useState([
        { id: 1, type: 'Credit Card', last4: '1234' },
        { id: 2, type: 'PayPal', email: 'john.paypal@example.com' },
    ]);

    const handleLogout = () => {
        console.log('User logged out');
        // Add logout logic here
    };

    const handleUpdateProfile = (e) => {
        e.preventDefault();
        console.log('Profile updated:', userInfo);
        // Add update logic here
    };

    return (
        <div>
            <h1>Profile Page</h1>

            {/* Editable Profile Information */}
            <section>
                <h2>Edit Profile</h2>
                <form onSubmit={handleUpdateProfile}>
                    <label>
                        Name:
                        <input
                            type="text"
                            value={userInfo.name}
                            onChange={(e) => setUserInfo({ ...userInfo, name: e.target.value })}
                        />
                    </label>
                    <label>
                        Email:
                        <input
                            type="email"
                            value={userInfo.email}
                            onChange={(e) => setUserInfo({ ...userInfo, email: e.target.value })}
                        />
                    </label>
                    <label>
                        Phone:
                        <input
                            type="tel"
                            value={userInfo.phone}
                            onChange={(e) => setUserInfo({ ...userInfo, phone: e.target.value })}
                        />
                    </label>
                    <button type="submit">Save Changes</button>
                </form>
            </section>

            {/* Order History */}
            <section>
                <h2>Order History</h2>
                <ul>
                    {orderHistory.map((order) => (
                        <li key={order.id}>
                            {order.date} - {order.items} - {order.total} - {order.status}
                        </li>
                    ))}
                </ul>
            </section>

            {/* Payment Methods */}
            <section>
                <h2>Payment Methods</h2>
                <ul>
                    {paymentMethods.map((method) => (
                        <li key={method.id}>
                            {method.type} - {method.last4 || method.email}
                        </li>
                    ))}
                </ul>
            </section>

            {/* Logout Option */}
            <section>
                <button onClick={handleLogout}>Logout</button>
            </section>
        </div>
    );
};

export default ProfilePage;
